import Foundation

struct TopicItemViewModel {
    let url: String
    init(with topic: Topic) {
        self.url = topic.url
    }
}
