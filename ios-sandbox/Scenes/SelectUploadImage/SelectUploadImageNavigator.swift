import UIKit

protocol SelectUploadImageNavigatorType {
    func toSelectUploadImage()
    func toCropUploadImage()
    func dismiss()
    static func root() -> UINavigationController
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

    func toCropUploadImage(_ image: UIImage) {
        let navigator = CropUploadImageNavigator(navigationController: navigationController)
        let viewModel = CropUploadImageViewModel(navigator: navigator, image: image)
        let viewController = CropUploadImageViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    func toCropUploadImage() {
    }

    func dismiss() {
        navigationController.dismiss(animated: true)
    }

    static func root() -> UINavigationController {
        let navigationController = UINavigationController()
        let navigator = self.init(navigationController: navigationController)
        navigator.toSelectUploadImage()

        return navigationController
    }
}
