import Foundation
import RxSwift
import RxCocoa

struct TopicViewModel {
    let username: BehaviorRelay<String>
    let imageUrl: BehaviorRelay<URL?>

    init(dependency topic: Item) {
        self.username = BehaviorRelay<String>(value: topic.username)
        self.imageUrl = BehaviorRelay<URL?>(value: URL(string: topic.username))
    }
}
