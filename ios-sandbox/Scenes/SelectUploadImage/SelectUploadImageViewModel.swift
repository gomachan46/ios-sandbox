import Foundation
import RxSwift
import RxCocoa
import Photos

struct SelectUploadImageViewModel {
    private let navigator: SelectUploadImageNavigator

    init(navigator: SelectUploadImageNavigator) {
        self.navigator = navigator
    }
}

extension SelectUploadImageViewModel: ViewModelType {
    struct Input {
        let refreshTrigger: Observable<Void>
    }

    struct Output {
        let sectionOfAlbums: Observable<[SectionOfAlbum]>
    }

    func transform(input: Input) -> Output {
        let photoAssets = input
            .refreshTrigger
            .flatMapLatest { _ -> Observable<[PHAsset]> in
                return Observable.create { observer -> Disposable in
                    print("hello")
                    observer.onNext(self.loadPhotoAssets())
                    return Disposables.create()
                }
            }
            .share(replay: 1)
        let sectionOfAlbums = photoAssets.map { [SectionOfAlbum(items: $0)] }

        return Output(sectionOfAlbums: sectionOfAlbums)
    }

    private func loadPhotoAssets() -> [PHAsset] {
        let options = PHFetchOptions().apply { this in
            this.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending:  false)]
        }
        let assets: PHFetchResult = PHAsset.fetchAssets(with: .image, options: options)
        var phAssets = [PHAsset]()
        assets.enumerateObjects(using: { (asset, index, stop) in
            phAssets.append(asset as PHAsset)
        })

        return phAssets
    }
}
