import Foundation

struct Bookmark {
    enum BookmarkType {
        case topic
        case image
    }

    var keyword: String
    var url: URL?
    var type: BookmarkType
}
