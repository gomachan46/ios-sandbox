import UIKit

protocol AllBookmarksNavigatorType {
    func toAllBookmarks()
    func toBookmark(_ bookmark: Bookmark)
    static func root() -> UINavigationController
}

struct AllBookmarksNavigator: AllBookmarksNavigatorType {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func toAllBookmarks() {
        let viewModel = AllBookmarksViewModel(navigator: self)
        let viewController = AllBookmarksViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    func toBookmark(_ bookmark: Bookmark) {
        // とりあえずtopicに
        let topic = Topic(username: bookmark.keyword, url: bookmark.url)
        let navigator = TopicNavigator(navigationController: navigationController)
        let viewModel = TopicViewModel(navigator: navigator, topic: topic)
        let viewController = TopicViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    static func root() -> UINavigationController {
        let navigationController = UINavigationController()
        let navigator = self.init(navigationController: navigationController)
        navigator.toAllBookmarks()

        return navigationController
    }
}
