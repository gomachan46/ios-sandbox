import Foundation

struct TopicItemViewModel {
    let url: String
    let topic: Topic

    init(with topic: Topic) {
        self.url = topic.url
        self.topic = topic
    }
}
