import UIKit

public protocol ZoomTransitionSourceDelegate: ZoomTransitionImageDelegate {
    var animationDuration: TimeInterval { get }
    func transitionSourceWillBegin()
    func transitionSourceDidEnd()
    func transitionSourceDidCancel()
    func zoomAnimation(animations: @escaping () -> Void, completion: ((Bool) -> Void)?)
}

extension ZoomTransitionSourceDelegate {
    var animationDuration: TimeInterval { return 0.3 }
    func transitionSourceWillBegin() {}
    func transitionSourceDidEnd() {}
    func transitionSourceDidCancel() {}
    func zoomAnimation(animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut, animations: animations, completion: completion)
    }
}
