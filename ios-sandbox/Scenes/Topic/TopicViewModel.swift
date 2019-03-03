import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator

struct TopicViewModel {
    private let navigator: TopicNavigator
    private let topics: Observable<Topic>

    init(navigator: TopicNavigator, topic: Topic) {
        self.navigator = navigator
        self.topics = Observable.of(topic)
    }
}

extension TopicViewModel: ViewModelType {
    struct Input {
    }

    struct Output {
    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
