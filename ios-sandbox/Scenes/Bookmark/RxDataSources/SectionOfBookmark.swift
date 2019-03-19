import Differentiator

struct SectionOfBookmark {
    var items: [Bookmark]
}

extension SectionOfBookmark: SectionModelType {
    typealias Item = Bookmark

    init(original: SectionOfBookmark, items: [SectionOfBookmark.Item]) {
        self = original
        self.items = items
    }
}