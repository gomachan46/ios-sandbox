import UIKit
import RxSwift

class CropUploadImageViewModel {
    private let navigator: CropUploadImageNavigator
    private let image: UIImage

    init(navigator: CropUploadImageNavigator, image: UIImage) {
        self.navigator = navigator
        self.image = image
    }
}

extension CropUploadImageViewModel: ViewModelType {
    struct Input {
    }

    struct Output {
        let croppedImage: Observable<UIImage>
    }

    func transform(input: Input) -> Output {
        let croppedImage = Observable.from(optional: image)
        return Output(croppedImage: croppedImage)
    }
}