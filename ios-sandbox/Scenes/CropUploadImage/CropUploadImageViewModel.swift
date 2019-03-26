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
        let currentText: Observable<String?>
    }

    struct Output {
        let croppedImage: Observable<UIImage>
        let shared: Observable<Void>
        let textViewPlaceHolderIsHidden: Observable<Bool>
        let textViewNumberOfCharactersText: Observable<String>
        let textViewNumberOfCharactersTextColor: Observable<UIColor>
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
        let numberOfCharacters = input.currentText.map { $0?.count ?? 0 }
        let textViewPlaceHolderIsHidden = numberOfCharacters.map { $0 > 0 }
        let textViewNumberOfCharactersText = numberOfCharacters.map { "\($0) / 150" }
        let textViewNumberOfCharactersTextColor: Observable<UIColor> = numberOfCharacters.map { $0 > 150 ? .red : .black }

        return Output(
            croppedImage: croppedImage,
            shared: shared,
            textViewPlaceHolderIsHidden: textViewPlaceHolderIsHidden,
            textViewNumberOfCharactersText: textViewNumberOfCharactersText,
            textViewNumberOfCharactersTextColor: textViewNumberOfCharactersTextColor
        )
    }
}
