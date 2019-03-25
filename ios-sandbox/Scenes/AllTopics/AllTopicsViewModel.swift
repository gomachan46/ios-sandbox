import Foundation
import RxSwift

class AllTopicsViewModel {
    let navigator: AllTopicsNavigator
    private var isFetching = Observable.from(optional: false)

    init(navigator: AllTopicsNavigator) {
        self.navigator = navigator
    }
}

extension AllTopicsViewModel: ViewModelType {
    struct Input {
        let selection: Observable<IndexPath>
        let refreshTrigger: Observable<Void>
    }

    struct Output {
        let sectionOfTopics: Observable<[SectionOfTopic]>
        let selectedTopic: Observable<Topic>
        let isFetching: Observable<Bool>
    }

    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
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
                    }.trackActivity(activityIndicator)
            }
            .share(replay: 1)

        let selectedTopic = input
            .selection
            .withLatestFrom(topics) { (indexPath, topics) -> Topic in topics[indexPath.row] }
            .do(onNext: navigator.toTopic)
        let sectionOfTopics = topics.map { [SectionOfTopic(items: $0)] }

        return Output(sectionOfTopics: sectionOfTopics, selectedTopic: selectedTopic, isFetching: activityIndicator.asObservable())
    }
}
