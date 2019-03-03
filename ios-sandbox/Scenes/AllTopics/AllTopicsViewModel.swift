import Foundation
import RxSwift
import RxCocoa
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

struct AllTopicsViewModel {
    private let navigator: AllTopicsNavigator
    private let topics: Observable<[Topic]>

    init(navigator: AllTopicsNavigator, topics: [Topic]) {
        self.navigator = navigator
        self.topics = Observable.of(topics)
    }
}

extension AllTopicsViewModel: ViewModelType {
    struct Input {
        let selection: Observable<IndexPath>
    }

    struct Output {
        let topics: Observable<[SectionOfTopic]>
        let selectedTopic: Observable<Topic>
    }

    func transform(input: Input) -> Output {
        let selectedTopic = input
            .selection
            .withLatestFrom(topics) { (indexPath, topics) -> Topic in
                return topics[indexPath.row]
            }
            .do(onNext: navigator.toTopic)
        let topicItemViewModels = topics.map { [SectionOfTopic(items: $0.map { TopicItemViewModel(with: $0) })] }
        return Output(topics: topicItemViewModels, selectedTopic: selectedTopic)
    }
}
