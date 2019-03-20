import UIKit

public protocol ZoomTransitionDestinationDelegate {
    func transitionDestinationImageView() -> UIImageView
    func transitionDestinationImageViewFrame(forward: Bool) -> CGRect
    func transitionDestinationWillBegin()
    func transitionDestinationDidEnd(transitioningImageView imageView: UIImageView)
    func transitionDestinationDidCancel()
}

public extension ZoomTransitionDestinationDelegate {
    func transitionDestinationWillBegin() {}
    func transitionDestinationDidEnd(transitioningImageView imageView: UIImageView) {}
    func transitionDestinationDidCancel() {}
}