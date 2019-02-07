import UIKit
import SnapKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setup()
    }
}

extension TabBarController
{
    enum Tab: String
    {
        case home     = "ホーム"
        case item     = "MYアイテム"
        case settings = "設定"
        case inquiry  = "ヘルプ"

        static let order: [Tab] = [.home, .item, .settings, .inquiry]

        var title: String { return rawValue }

        var viewController: UIViewController {
            switch self {
            case .home:     return SampleCollectionViewController()
            case .item:     return SampleCollectionViewController()
            case .settings: return SampleCollectionViewController()
            case .inquiry:  return SampleCollectionViewController()
            }
        }

        var image: (on: UIImage, off: UIImage) {
            switch self {
            case .home:
                return (R.image.tabAOff_23x23()!.withRenderingMode(.alwaysOriginal),
                    R.image.tabAOff_23x23()!.withRenderingMode(.alwaysOriginal))
            case .item:
                return (R.image.tabAOff_23x23()!.withRenderingMode(.alwaysOriginal),
                    R.image.tabAOff_23x23()!.withRenderingMode(.alwaysOriginal))
            case .settings:
                return (R.image.tabAOff_23x23()!.withRenderingMode(.alwaysOriginal),
                    R.image.tabAOff_23x23()!.withRenderingMode(.alwaysOriginal))
            case .inquiry:
                return (R.image.tabAOff_23x23()!.withRenderingMode(.alwaysOriginal),
                    R.image.tabAOff_23x23()!.withRenderingMode(.alwaysOriginal))
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
