import Differentiator

struct SectionOfBookMark {
    var items: [BookMark]
}

extension SectionOfBookMark: SectionModelType {
    typealias Item = BookMark

    init(original: SectionOfBookMark, items: [SectionOfBookMark.Item]) {
        self = original
        self.items = items
    }
}