import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class ItemPageViewController: UIPageViewController {
    private var contentVCs = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dataSource = self

        (1...5).forEach { i in
            let contentVC = ItemZoomViewController(item: Item(username: "John", url: "https://picsum.photos/300?image=\(Int.random(in: (1...100)))"))
            contentVCs.append(contentVC)
        }
        setViewControllers([contentVCs[0]], direction: .forward, animated: true)
    }
}

extension ItemPageViewController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = contentVCs.firstIndex(of: viewController), index != NSNotFound else { return nil }
        if index > 0 {
            return contentVCs[index - 1]
        } else {
            return nil
        }
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = contentVCs.firstIndex(of: viewController), index != NSNotFound else { return nil }
        if index < contentVCs.count - 1 {
            return contentVCs[index + 1]
        } else {
            return nil
        }
    }
}
