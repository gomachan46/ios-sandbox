import UIKit

protocol CropUploadImageNavigatorType {
}

struct CropUploadImageNavigator: CropUploadImageNavigatorType {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
