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

    }

    func toAllTopics() {
        let topics = (0..<30).map { _ in Topic(username: "John", url: "https://picsum.photos/300?image=\(Int.random(in: 1...100))") }
        let viewModel = AllTopicsViewModel(navigator: self, topics: topics)
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
