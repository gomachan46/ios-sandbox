import UIKit

final class ZoomTransitioningNavigationController: UINavigationController {
    private let zoomNavigationControllerDelegate: ZoomNavigationControllerDelegate = .init()

    init() {
        super.init(nibName: nil, bundle: nil)
        delegate = zoomNavigationControllerDelegate
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
