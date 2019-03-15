import Foundation
import RxSwift
import RxCocoa

struct BookMarkViewModel {
    private let navigator: BookMarkNavigator

    init(navigator: BookMarkNavigator) {
        self.navigator = navigator
    }
}

extension BookMarkViewModel: ViewModelType {
    struct Input {
        let refreshTrigger: Observable<Void>
    }

    struct Output {
        let sectionOfBookMark: Observable<[SectionOfBookMark]>
    }

    func transform(input: Input) -> Output {
        let topics = input
            .refreshTrigger
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .userInteractive))
            .flatMapLatest { _ -> Observable<[BookMark]> in
                // API叩いてデータ取ってきて[BookMark]を取得する、みたいなところのイメージ
                // ちゃんとするなら外出ししていくはず
                return Observable.create { observer -> Disposable in
                    Thread.sleep(forTimeInterval: 1)
                    observer.onNext(
                        (0..<30).map { _ in
                            [
                                BookMark(keyword: "レースブラウス", url: URL(string: "https://picsum.photos/300/600?image=\(Int.random(in: 1...100))")),
                                BookMark(keyword: "who's who Chico(フーズフーチコ)のオサイフドッキングポシェット", url: URL(string: "https://picsum.photos/300/600?image=\(Int.random(in: 1...100))")),
                                BookMark(keyword: nil, url: URL(string: "https://picsum.photos/300/300?image=\(Int.random(in: 1...100))"))
                            ].shuffled().first!
                        }
                    )
                    return Disposables.create()
                }
            }
            .share(replay: 1)
        let sectionOfBookMark = topics.map { [SectionOfBookMark(items: $0)] }

        return Output(sectionOfBookMark: sectionOfBookMark)
    }
}
