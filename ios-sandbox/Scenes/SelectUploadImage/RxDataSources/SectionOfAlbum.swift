import Differentiator
import Photos

struct SectionOfAlbum {
    var items: [PHAsset]
}

extension SectionOfAlbum: SectionModelType {
    typealias Item = PHAsset

    init(original: SectionOfAlbum, items: [SectionOfAlbum.Item]) {
        self = original
        self.items = items
    }
}
