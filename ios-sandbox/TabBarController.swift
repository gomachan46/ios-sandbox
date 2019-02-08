import UIKit
import SnapKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setup()
    }
}

extension TabBarController {
    enum Tab: String {
        case a = "a"
        case b = "b"
        case c = "c"
        case d = "d"

        static let order: [Tab] = [.a, .b, .c, .d]

        var title: String {
            return rawValue
        }

        var viewController: UIViewController {
            switch self {
            case .a: return UINavigationController(rootViewController: ItemCollectionViewController())
            case .b: return UINavigationController(rootViewController: ItemCollectionViewController())
            case .c: return UINavigationController(rootViewController: ItemCollectionViewController())
            case .d: return UINavigationController(rootViewController: ItemCollectionViewController())
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
}
