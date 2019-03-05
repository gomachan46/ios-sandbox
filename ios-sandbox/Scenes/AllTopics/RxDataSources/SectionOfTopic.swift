import Differentiator

struct SectionOfTopic {
    var items: [Topic]
}

extension SectionOfTopic: SectionModelType {
    typealias Item = Topic

    init(original: SectionOfTopic, items: [SectionOfTopic.Item]) {
        self = original
        self.items = items
    }
}