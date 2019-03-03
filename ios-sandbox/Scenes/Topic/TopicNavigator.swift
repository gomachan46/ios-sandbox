import UIKit

protocol TopicNavigatorType {
    func toAllTopics()
}

struct TopicNavigator: TopicNavigatorType {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func toAllTopics() {
        navigationController.popViewController(animated: true)
    }
}
