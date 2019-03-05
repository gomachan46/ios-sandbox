import Foundation
import RxSwift
import RxDataSources
import Differentiator
import Kingfisher

struct SectionOfTopic {
    var items: [TopicItemViewModel]
}

extension SectionOfTopic: SectionModelType {
    typealias Item = TopicItemViewModel

    init(original: SectionOfTopic, items: [SectionOfTopic.Item]) {
        self = original
        self.items = items
    }
}

class AllTopicsViewModel {
    private let navigator: AllTopicsNavigator
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
        let topics: Observable<[SectionOfTopic]>
        let selectedTopic: Observable<Topic>
        let isFetching: Observable<Bool>
    }

    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let topics = input
            .refreshTrigger
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .userInteractive))
            .flatMapLatest { _ -> Observable<[Topic]> in
                return Observable.create { observer -> Disposable in
                        // API叩いてデータ取ってきて[Topic]、みたいなところのイメージ
                        Thread.sleep(forTimeInterval: 1)
                        observer.onNext(
                            (0..<30).map { _ in Topic(username: "John", url: "https://picsum.photos/300?image=\(Int.random(in: 1...100))") }
                        )
                        return Disposables.create()
                }.trackActivity(activityIndicator)
            }
            .share(replay: 1)

        let selectedTopic = input
            .selection
            .withLatestFrom(topics) {
                (indexPath, topics) -> Topic in topics[indexPath.row]
            }
            .do(onNext: navigator.toTopic)
        let topicItemViewModels = topics.map { [SectionOfTopic(items: $0.map { TopicItemViewModel(with: $0) })] }

        return Output(topics: topicItemViewModels, selectedTopic: selectedTopic, isFetching: activityIndicator.asObservable())
    }
}
