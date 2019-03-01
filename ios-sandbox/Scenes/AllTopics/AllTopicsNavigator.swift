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

    }

    static func root() -> UINavigationController {
        let viewModel = AllTopicsViewModel()
        let viewController = AllTopicsViewController(viewModel: viewModel)
        return UINavigationController(rootViewController: viewController)
    }
}
