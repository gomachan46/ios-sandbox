import Foundation
import RxSwift
import RxCocoa

struct TopicViewModel {
    private let navigator: TopicNavigator
    private let topic: Observable<Topic>

    init(navigator: TopicNavigator, topic: Topic) {
        self.navigator = navigator
        self.topic = Observable.of(topic)
    }
}

extension TopicViewModel: ViewModelType {
    struct Input {
    }

    struct Output {
        let topic: Observable<Topic>
    }

    func transform(input: Input) -> Output {
        return Output(topic: topic)
    }
}
