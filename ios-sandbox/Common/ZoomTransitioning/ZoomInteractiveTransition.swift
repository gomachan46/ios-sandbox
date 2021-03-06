import UIKit

public final class ZoomInteractiveTransition: UIPercentDrivenInteractiveTransition {
    weak var navigationController: UINavigationController?
    weak var zoomPopGestureRecognizer: UIPanGestureRecognizer?
    private weak var viewController: UIViewController?
    private var interactive: Bool = false

    var interactionController: ZoomInteractiveTransition? {
        return interactive ? self : nil
    }

    @objc func handle(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .changed:
            guard let view = recognizer.view else { return }
            let progress = max(recognizer.translation(in: view).x / view.bounds.width, recognizer.translation(in: view).y / view.bounds.height)
            update(progress)
        case .cancelled, .ended:
            guard let view = recognizer.view else { return }
            let progress = max(recognizer.translation(in: view).x / view.bounds.width, recognizer.translation(in: view).y / view.bounds.height)
            let velocity = max(recognizer.velocity(in: view).x, recognizer.velocity(in: view).y)
            if progress > 0.33 || velocity > 1000 {
                finish()
            } else {
                if let viewController = viewController {
                    navigationController?.viewControllers.append(viewController)
                    update(0)
                }
                cancel()

                if let viewController = viewController as? ZoomTransitionDestinationDelegate {
                    viewController.transitionDestinationDidCancel()
                }
                if let viewController = navigationController?.viewControllers.last as? ZoomTransitionSourceDelegate {
                    viewController.transitionSourceDidCancel()
                }
            }
            interactive = false
        default:
            break
        }
    }
}

extension ZoomInteractiveTransition: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let isDestinationController: Bool = navigationController?.viewControllers.last is ZoomTransitionDestinationDelegate
        if gestureRecognizer === navigationController?.interactivePopGestureRecognizer {
            return !isDestinationController
        } else if gestureRecognizer === zoomPopGestureRecognizer {
            if isDestinationController {
                interactive = true
                viewController = navigationController?.popViewController(animated: true)
                return true
            }
        }
        return false
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return otherGestureRecognizer === navigationController?.interactivePopGestureRecognizer
    }
}
