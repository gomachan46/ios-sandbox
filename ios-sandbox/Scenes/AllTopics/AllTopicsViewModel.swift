import Foundation
import RxSwift
import RxCocoa

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
        let topics: Driver<[TopicItemViewModel]>
    }

    func transform(input: Input) -> Output {
        let topics = Driver.of(self.topics.map { TopicItemViewModel(with: $0) })
        return Output(topics: topics)
    }
}
