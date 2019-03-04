import Foundation
import RxSwift
import RxDataSources
import Differentiator

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
    private var topics: Observable<[Topic]>!
    private var isFetching = Observable.from(optional: false)

    init(navigator: AllTopicsNavigator) {
        self.navigator = navigator
        fetchTopics()
    }
}

extension AllTopicsViewModel {
    private func fetchTopics() {
        self.topics = Observable.from(
            optional: (0..<30).map { _ in
                Topic(username: "John", url: "https://picsum.photos/300?image=\(Int.random(in: 1...100))")
            }
        )
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
        let fetching: Observable<Bool>
    }

    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let topics = input
            .refreshTrigger
            .flatMapLatest {
                return self.topics
                    .trackActivity(activityIndicator)
            }

        let selectedTopic = input
            .selection
            .withLatestFrom(topics) {
                (indexPath, topics) -> Topic in topics[indexPath.row]
            }
            .do(onNext: navigator.toTopic)
        let topicItemViewModels = topics.map { [SectionOfTopic(items: $0.map { TopicItemViewModel(with: $0) })] }

        return Output(topics: topicItemViewModels, selectedTopic: selectedTopic, fetching: activityIndicator.asObservable())
    }
}
