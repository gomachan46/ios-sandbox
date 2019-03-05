import Foundation
import RxSwift
import RxCocoa

struct SelectUploadImageViewModel {
    private let navigator: SelectUploadImageNavigator

    init(navigator: SelectUploadImageNavigator) {
        self.navigator = navigator
    }
}

extension SelectUploadImageViewModel: ViewModelType {
    struct Input {
        let refreshTrigger: Observable<Void>
    }

    struct Output {
        let sectionOfAlbums: Observable<[SectionOfAlbum]>
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
        let sectionOfAlbums = topics.map { [SectionOfAlbum(items: $0)] }

        return Output(sectionOfAlbums: sectionOfAlbums)
    }
}
