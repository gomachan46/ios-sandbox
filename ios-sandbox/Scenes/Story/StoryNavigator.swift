import UIKit

protocol StoryNavigatorType {
    func dismiss()
}

struct StoryNavigator: StoryNavigatorType {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func dismiss() {
        navigationController.dismiss(animated: true)
    }
}
