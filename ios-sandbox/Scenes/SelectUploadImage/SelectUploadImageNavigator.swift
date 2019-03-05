import UIKit

protocol SelectUploadImageNavigatorType {
}

struct SelectUploadImageNavigator: SelectUploadImageNavigatorType {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func toSelectUploadImage() {
        let viewModel = SelectUploadImageViewModel(navigator: self)
        let viewController = SelectUploadImageViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    static func root() -> UINavigationController {
        let navigationController = UINavigationController()
        let navigator = self.init(navigationController: navigationController)
        navigator.toSelectUploadImage()

        return navigationController
    }
}
