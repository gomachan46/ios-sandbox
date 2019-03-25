import UIKit

public final class ZoomTransitioning: NSObject {
    static let transitionDuration: TimeInterval = 0.3
    private let source: ZoomTransitionSourceDelegate
    private let destination: ZoomTransitionDestinationDelegate
    private let forward: Bool

    required public init(source: ZoomTransitionSourceDelegate, destination: ZoomTransitionDestinationDelegate, forward: Bool) {
        self.source = source
        self.destination = destination
        self.forward = forward

        super.init()
    }
}

extension ZoomTransitioning: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return source.animationDuration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if forward {
            animateTransition(transitionContext, fromTransition: source, toTransition: destination)
        } else {
            animateTransition(transitionContext, fromTransition: destination, toTransition: source)
        }
    }

    private func animateTransition(_ transitionContext: UIViewControllerContextTransitioning, fromTransition: ZoomTransitionImageDelegate, toTransition: ZoomTransitionImageDelegate) {
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from),
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return
        }

        let transitioningImageView = makeTransitioningImageView(fromTransition: fromTransition)
        transitionContext.containerView.apply { this in
            this.addSubview(transitioningImageView)
            this.backgroundColor = fromView.backgroundColor
            this.insertSubview(toView, belowSubview: fromView)
        }

        fromView.alpha = 1
        toView.alpha = 0

        source.transitionSourceWillBegin()
        destination.transitionDestinationWillBegin()

        source.zoomAnimation(
            animations: {
                fromView.alpha = 0
                toView.alpha = 1
                transitioningImageView.layer.cornerRadius = toTransition.transitionImageView().layer.cornerRadius
                transitioningImageView.frame = toTransition.transitionImageViewFrame(forward: self.forward)
        },
            completion: { _ in
                fromView.alpha = 1
                transitioningImageView.removeFromSuperview()
                self.source.transitionSourceDidEnd()
                self.destination.transitionDestinationDidEnd(transitioningImageView: transitioningImageView)
                transitionContext.completeTransition(true)
        })

    }

    private func makeTransitioningImageView(fromTransition: ZoomTransitionImageDelegate) -> UIImageView {
        return UIImageView(frame: fromTransition.transitionImageViewFrame(forward: forward)).apply { this in
            let imageView = fromTransition.transitionImageView()
            this.image = imageView.image
            this.contentMode = imageView.contentMode
            this.clipsToBounds = true
            this.layer.cornerRadius = imageView.layer.cornerRadius
        }
    }
}
