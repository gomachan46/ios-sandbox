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
            .flatMapLatest { _ -> Observable<[Topic]> in
                // API叩いてデータ取ってきて[Topic]を取得する、みたいなところのイメージ
                // ちゃんとするなら外出ししていくはず
                return Observable.create { observer -> Disposable in
                    Thread.sleep(forTimeInterval: 1)
                    observer.onNext(
                        (0..<30).map { _ in
                            Topic(
                                username: "John",
                                url: URL(string: "https://picsum.photos/300?image=\(Int.random(in: 1...100))")
                            )
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
