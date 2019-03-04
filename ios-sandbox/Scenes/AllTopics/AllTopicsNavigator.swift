import UIKit

protocol AllTopicsNavigatorType {
    func toTopic(_ topic: Topic)
    func toAllTopics()
    static func root() -> UINavigationController
}

struct AllTopicsNavigator: AllTopicsNavigatorType {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func toTopic(_ topic: Topic) {
        let navigator = TopicNavigator(navigationController: navigationController)
        let viewModel = TopicViewModel(navigator: navigator, topic: topic)
        let viewController = TopicViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    func toAllTopics() {
        let viewModel = AllTopicsViewModel(navigator: self)
        let viewController = AllTopicsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    static func root() -> UINavigationController {
        let navigationController = UINavigationController()
        let navigator = self.init(navigationController: navigationController)
        navigator.toAllTopics()

        return navigationController
    }
}
