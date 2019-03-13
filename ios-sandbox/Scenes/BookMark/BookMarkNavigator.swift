import UIKit

protocol BookMarkNavigatorType {
    func toBookMark()
    static func root() -> UINavigationController
}

struct BookMarkNavigator: BookMarkNavigatorType {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func toBookMark() {
        let viewModel = BookMarkViewModel(navigator: self)
        let viewController = BookMarkViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    static func root() -> UINavigationController {
        let navigationController = UINavigationController()
        let navigator = self.init(navigationController: navigationController)
        navigator.toBookMark()

        return navigationController
    }
}
