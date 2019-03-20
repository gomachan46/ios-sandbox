import UIKit

public protocol ZoomTransitionDestinationDelegate: ZoomTransitionImageDelegate {
    func transitionDestinationWillBegin()
    func transitionDestinationDidEnd(transitioningImageView imageView: UIImageView)
    func transitionDestinationDidCancel()
}

public extension ZoomTransitionDestinationDelegate {
    func transitionDestinationWillBegin() {}
    func transitionDestinationDidEnd(transitioningImageView imageView: UIImageView) {}
    func transitionDestinationDidCancel() {}
}
