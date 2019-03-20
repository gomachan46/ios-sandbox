import UIKit

public protocol ZoomTransitionImageDelegate {
    func transitionImageView() -> UIImageView
    func transitionImageViewFrame(forward: Bool) -> CGRect
}
