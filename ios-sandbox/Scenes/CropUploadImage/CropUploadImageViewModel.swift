import UIKit

class CropUploadImageViewModel {
    private let navigator: CropUploadImageNavigator
    private let image: UIImage

    init(navigator: CropUploadImageNavigator, image: UIImage) {
        self.navigator = navigator
        self.image = image
    }
}