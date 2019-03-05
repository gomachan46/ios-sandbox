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
        let username: Observable<String>
        let url: Observable<URL?>
    }

    func transform(input: Input) -> Output {
        let username = topic.map { $0.username }
        let url = topic.map { $0.url }
        return Output(topic: topic, username: username, url: url)
    }
}
