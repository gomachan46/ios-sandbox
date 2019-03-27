import UIKit

public final class ZoomNavigationControllerDelegate: NSObject {
    private let zoomInteractiveTransition: ZoomInteractiveTransition = .init()
    private let zoomPopGestureRecognizer: UIPanGestureRecognizer = .init()
}

extension ZoomNavigationControllerDelegate: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if zoomPopGestureRecognizer.delegate !== zoomInteractiveTransition {
            zoomPopGestureRecognizer.delegate = zoomInteractiveTransition
            zoomPopGestureRecognizer.addTarget(zoomInteractiveTransition, action: #selector(ZoomInteractiveTransition.handle(recognizer:)))
            navigationController.view.addGestureRecognizer(zoomPopGestureRecognizer)
            zoomInteractiveTransition.zoomPopGestureRecognizer = zoomPopGestureRecognizer
        }

        if let interactivePopGestureRecognizer = navigationController.interactivePopGestureRecognizer, interactivePopGestureRecognizer.delegate !== zoomInteractiveTransition {
            zoomInteractiveTransition.navigationController = navigationController
            interactivePopGestureRecognizer.delegate = zoomInteractiveTransition
        }
    }

    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return zoomInteractiveTransition.interactionController
    }

    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            guard let source = fromVC as? ZoomTransitionSourceDelegate, let destination = toVC as? ZoomTransitionDestinationDelegate else {
                return nil
            }
            return ZoomTransitioning(source: source, destination: destination, forward: true)
        case .pop:
            guard let source = toVC as? ZoomTransitionSourceDelegate, let destination = fromVC as? ZoomTransitionDestinationDelegate else {
                return nil
            }
            return ZoomTransitioning(source: source, destination: destination, forward: false)
        case .none:
            return nil
        default:
            return nil
        }
    }
}
