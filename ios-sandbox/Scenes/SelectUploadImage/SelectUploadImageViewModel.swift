import Foundation
import RxSwift
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
        let tapCancel: Observable<Void>
        let selection: Observable<IndexPath>
        let tapNext: Observable<UIImage>
    }

    struct Output {
        let sectionOfAlbums: Observable<[SectionOfAlbum]>
        let canceled: Observable<Void>
        let selectedPhotoAsset: Observable<PHAsset>
        let wentToNext: Observable<UIImage>
    }

    func transform(input: Input) -> Output {
        let photoAssets = input
            .refreshTrigger
            .flatMapLatest { _ -> Observable<[PHAsset]> in
                return Observable.create { observer -> Disposable in
                    observer.onNext(self.loadPhotoAssets())
                    return Disposables.create()
                }
        }
        let sectionOfAlbums = photoAssets.map { [SectionOfAlbum(items: $0)] }
        let canceled = input.tapCancel.do(onNext: navigator.dismiss)
        let selectedPhotoAsset = input
            .selection
            .withLatestFrom(photoAssets) { (indexPath, photoAssets) -> PHAsset in
                return photoAssets[indexPath.row]
        }
        let wentToNext = input
            .tapNext
            .do(onNext: { image in self.navigator.toCropUploadImage(image) })

        return Output(sectionOfAlbums: sectionOfAlbums, canceled: canceled, selectedPhotoAsset: selectedPhotoAsset, wentToNext: wentToNext)
    }

    private func loadPhotoAssets() -> [PHAsset] {
        let options = PHFetchOptions().apply { this in
            this.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        }
        let assets: PHFetchResult = PHAsset.fetchAssets(with: .image, options: options)
        var phAssets = [PHAsset]()
        assets.enumerateObjects(using: { (asset, _, _) in
            phAssets.append(asset as PHAsset)
        })

        return phAssets
    }
}
