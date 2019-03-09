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
        let share: Observable<Void>
    }

    struct Output {
        let croppedImage: Observable<UIImage>
        let shared: Observable<Void>
    }

    func transform(input: Input) -> Output {
        let croppedImage = Observable.from(optional: image)
        let shared = input
            .share
            .do(
                onNext: { _ in
                    let urlScheme = URL(string: "instagram-stories://share")!
                    let imageData = self.image.pngData() as Any
                    let items = [["com.instagram.sharedSticker.stickerImage": imageData]]
                    if UIApplication.shared.canOpenURL(urlScheme) {
                        let options: [UIPasteboard.OptionsKey: Any] = [.expirationDate: Date().addingTimeInterval(60 * 5)]
                        UIPasteboard.general.setItems(items, options: options)
                        UIApplication.shared.open(urlScheme)
                    }
                }
            )
        return Output(croppedImage: croppedImage, shared: shared)
    }
}