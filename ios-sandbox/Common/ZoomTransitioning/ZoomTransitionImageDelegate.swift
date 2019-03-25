import UIKit

public protocol ZoomTransitionImageDelegate: class {
    func transitionImageView() -> UIImageView
    func transitionImageViewFrame(forward: Bool) -> CGRect
}
