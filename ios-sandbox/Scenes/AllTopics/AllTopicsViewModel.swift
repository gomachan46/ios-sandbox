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
    private let topics: [Topic]

    init(navigator: AllTopicsNavigator, topics: [Topic]) {
        self.navigator = navigator
        self.topics = topics
    }
}

extension AllTopicsViewModel: ViewModelType {
    struct Input {
    }

    struct Output {
        let topics: Driver<[SectionOfTopic]>
    }

    func transform(input: Input) -> Output {
        let topicItemViewModels = topics.map { TopicItemViewModel(with: $0) }
        return Output(topics: Driver.of([SectionOfTopic(items: topicItemViewModels)]))
    }
}
