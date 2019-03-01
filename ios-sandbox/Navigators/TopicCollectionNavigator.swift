import UIKit

protocol TopicCollectionNavigator {
    func toTopic(_ topic: Item)
    func toTopicCollection()
}

struct DefaultTopicCollectionNavigator: TopicCollectionNavigator {
    func toTopic(_ topic: Item) {
    }

    func toTopicCollection() {
    }
}
