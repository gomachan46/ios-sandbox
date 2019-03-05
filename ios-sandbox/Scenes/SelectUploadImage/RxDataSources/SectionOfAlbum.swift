import Differentiator

struct SectionOfAlbum{
    var items: [Topic]
}

extension SectionOfAlbum: SectionModelType {
    typealias Item = Topic

    init(original: SectionOfAlbum, items: [SectionOfAlbum.Item]) {
        self = original
        self.items = items
    }
}