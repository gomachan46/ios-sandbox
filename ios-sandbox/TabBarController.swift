import UIKit
import SnapKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        UIButton().apply { this in
            tabBar.addSubview(this)
            this.setTitle("＋", for: .normal)
            this.backgroundColor = .orange
            this.sizeToFit()
            this.addTarget(self, action: #selector(tapCenterButton), for: .touchUpInside)
            this.snp.makeConstraints { make in
                make.center.equalTo(tabBar)
                make.width.equalTo(tabBar).dividedBy(5)
                make.height.equalTo(tabBar)
            }
        }
    }
}

extension TabBarController {
    enum Tab {
        case a
        case b
        case c
        case d
        case e

        static let order: [Tab] = [.a, .b, .c, .d, .e]

        var viewController: UIViewController {
            switch self {
            case .a: return AllTopicsNavigator.root()
            case .b: return UINavigationController(rootViewController: TopicCollectionViewController(topics: (0..<30).map { _ in Item(username: "John", url: "https://picsum.photos/300?image=\(Int.random(in: 1...100))") }))
            case .c: return UINavigationController(rootViewController: ItemCollectionViewController())
            case .d: return UINavigationController(rootViewController: ItemCollectionViewController())
            case .e: return AllBookmarksNavigator.root()
            }
        }

        var image: (on: UIImage, off: UIImage) {
            switch self {
            case .a:
                return (R.image.tabActive_25x25()!.withRenderingMode(.alwaysOriginal),
                        R.image.tabInactive_25x25()!.withRenderingMode(.alwaysOriginal))
            case .b:
                return (R.image.tabActive_25x25()!.withRenderingMode(.alwaysOriginal),
                        R.image.tabInactive_25x25()!.withRenderingMode(.alwaysOriginal))
            case .c:
                return (R.image.tabActive_25x25()!.withRenderingMode(.alwaysOriginal),
                        R.image.tabInactive_25x25()!.withRenderingMode(.alwaysOriginal))
            case .d:
                return (R.image.tabActive_25x25()!.withRenderingMode(.alwaysOriginal),
                        R.image.tabInactive_25x25()!.withRenderingMode(.alwaysOriginal))
            case .e:
                return (R.image.tabActive_25x25()!.withRenderingMode(.alwaysOriginal),
                        R.image.tabInactive_25x25()!.withRenderingMode(.alwaysOriginal))
            }
        }
    }

    private func setup() {
        let vcs = Tab.order.map { item -> UIViewController in
            return item.viewController.apply { this in
                this.tabBarItem = UITabBarItem(title: nil, image: item.image.off, selectedImage: item.image.on)
            }
        }
        setViewControllers(vcs, animated: false)
    }

    @objc private func tapCenterButton() {
        present(SelectUploadImageNavigator.root(), animated: true)
    }
}
