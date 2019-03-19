import UIKit

protocol BookmarkNavigatorType {
    func toBookmark()
    static func root() -> UINavigationController
}

struct BookmarkNavigator: BookmarkNavigatorType {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func toBookmark() {
        let viewModel = BookmarkViewModel(navigator: self)
        let viewController = BookmarkViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    static func root() -> UINavigationController {
        let navigationController = UINavigationController()
        let navigator = self.init(navigationController: navigationController)
        navigator.toBookmark()

        return navigationController
    }
}
