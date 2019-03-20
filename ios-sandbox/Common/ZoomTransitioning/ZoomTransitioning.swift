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
            animateTransitionForPush(transitionContext)
        } else {
            animateTransitionForPop(transitionContext)
        }
    }

    private func animateTransitionForPush(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let sourceView = transitionContext.view(forKey: UITransitionContextViewKey.from),
              let destinationView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            return
        }

        let containerView: UIView = transitionContext.containerView
        let transitioningImageView: UIImageView = transitioningPushImageView()

        containerView.backgroundColor = sourceView.backgroundColor
        sourceView.alpha = 1
        destinationView.alpha = 0

        containerView.insertSubview(destinationView, belowSubview: sourceView)
        containerView.addSubview(transitioningImageView)

        source.transitionSourceWillBegin()
        destination.transitionDestinationWillBegin()

        source.zoomAnimation(
            animations: {
                sourceView.alpha = 0
                destinationView.alpha = 1
                transitioningImageView.frame = self.destination.transitionDestinationImageViewFrame(forward: self.forward)
            },
            completion: { _ in
                sourceView.alpha = 1
                transitioningImageView.alpha = 0
                transitioningImageView.removeFromSuperview()

                self.source.transitionSourceDidEnd()
                self.destination.transitionDestinationDidEnd(transitioningImageView: transitioningImageView)

                let completed: Bool = !transitionContext.transitionWasCancelled
                transitionContext.completeTransition(completed)
            })
    }

    private func animateTransitionForPop(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let sourceView = transitionContext.view(forKey: UITransitionContextViewKey.to),
              let destinationView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            return
        }

        let containerView: UIView = transitionContext.containerView
        let transitioningImageView: UIImageView = transitioningPopImageView()

        containerView.backgroundColor = destinationView.backgroundColor
        destinationView.alpha = 1
        sourceView.alpha = 0

        containerView.insertSubview(sourceView, belowSubview: destinationView)
        containerView.addSubview(transitioningImageView)

        source.transitionSourceWillBegin()
        destination.transitionDestinationWillBegin()

        if transitioningImageView.frame.maxY < 0 {
            transitioningImageView.frame.origin.y = -transitioningImageView.frame.height
        }
        source.zoomAnimation(
            animations: {
                destinationView.alpha = 0
                sourceView.alpha = 1
                transitioningImageView.frame = self.source.transitionSourceImageViewFrame(forward: self.forward)
            },
            completion: { _ in
                destinationView.alpha = 1
                transitioningImageView.removeFromSuperview()

                self.source.transitionSourceDidEnd()
                self.destination.transitionDestinationDidEnd(transitioningImageView: transitioningImageView)

                let completed: Bool
                if #available(iOS 10.0, *) {
                    completed = true
                } else {
                    completed = !transitionContext.transitionWasCancelled
                }
                transitionContext.completeTransition(completed)
            })
    }

    private func transitioningPushImageView() -> UIImageView {
        let imageView: UIImageView = source.transitionSourceImageView()
        let frame: CGRect = source.transitionSourceImageViewFrame(forward: forward)
        return UIImageView(frame: frame).apply { this in
            this.image = imageView.image
            this.contentMode = imageView.contentMode
            this.clipsToBounds = true
        }
    }

    private func transitioningPopImageView() -> UIImageView {
        let imageView: UIImageView = source.transitionSourceImageView()
        let frame: CGRect = destination.transitionDestinationImageViewFrame(forward: forward)
        return UIImageView(frame: frame).apply { this in
            this.image = imageView.image
            this.contentMode = imageView.contentMode
            this.clipsToBounds = true
        }
    }
}