import Differentiator

struct SectionOfBookMark {
    var items: [Topic]
}

extension SectionOfBookMark: SectionModelType {
    typealias Item = Topic

    init(original: SectionOfBookMark, items: [SectionOfBookMark.Item]) {
        self = original
        self.items = items
    }
}