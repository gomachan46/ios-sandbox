import UIKit

protocol ZoomTransitioningSource
{
    var imageView: UIImageView { get }
}

class ZoomTransitioning: NSObject
{
    private let source: ZoomTransitioningSource
    private var isPresent: Bool = false

    init(source: ZoomTransitioningSource) {
        self.source = source
        super.init()
    }
}

extension ZoomTransitioning
{
    // 遷移時のTransition処理
    private func presentTransition(transitionContext: UIViewControllerContextTransitioning) {
        let detailVC = transitionContext.viewController(forKey: .to) as! TopicViewController // TODO: protocol化する
        let containerView = transitionContext.containerView
        let sourceImageView = source.imageView
        // 遷移元のイメージビューからアニメーション用のビューを作成
        let animationView = UIImageView(image: sourceImageView.image)
        animationView.frame = containerView.convert(sourceImageView.frame, from: sourceImageView.superview)

        sourceImageView.isHidden = true

        detailVC.view.alpha = 0
        detailVC.imageView.isHidden = true
        detailVC.view.layoutIfNeeded()

        // 遷移コンテナに、遷移後のビューと、アニメーション用のビューを追加する
        containerView.addSubview(detailVC.view)
        containerView.addSubview(animationView)

        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                detailVC.view.alpha = 1.0
                let imageViewFrame = detailVC.imageView.frame
                let detailImageViewRect = CGRect(
                    x: imageViewFrame.origin.x + detailVC.view.safeAreaInsets.left,
                    y: imageViewFrame.origin.y + detailVC.view.safeAreaInsets.top,
                    width: imageViewFrame.size.width,
                    height: imageViewFrame.size.height
                )
                animationView.frame = containerView.convert(detailImageViewRect, from: detailVC.imageView.superview)
            },
            completion: { _ in
                detailVC.imageView.isHidden = false
                sourceImageView.isHidden = false
                animationView.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        )
    }

    // 復帰時のTransition処理
    private func dismissTransition(transitionContext: UIViewControllerContextTransitioning) {
        let detailVC = transitionContext.viewController(forKey: .from) as! TopicViewController
        let containerView = transitionContext.containerView
        let sourceImageView = source.imageView
        // 遷移元のイメージビューからアニメーション用のビューを作成
        let animationView = detailVC.imageView.snapshotView(afterScreenUpdates: false)!
        animationView.frame = containerView.convert(detailVC.imageView.frame, from: detailVC.imageView.superview)

        detailVC.imageView.isHidden = true

        // 遷移コンテナに、遷移後のビューと、アニメーション用のビューを追加する
        containerView.addSubview(animationView)

        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                detailVC.view.alpha = 0
                animationView.frame = containerView.convert(sourceImageView.frame, from: sourceImageView.superview)
            },
            completion: { _ in
                animationView.removeFromSuperview()
                detailVC.imageView.isHidden = false
                sourceImageView.isHidden = false
                transitionContext.completeTransition(true)
            }
        )
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension ZoomTransitioning: UIViewControllerAnimatedTransitioning
{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            presentTransition(transitionContext: transitionContext)
        } else {
            dismissTransition(transitionContext: transitionContext)
        }
    }
}

extension ZoomTransitioning: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            isPresent = true
        case .pop, .none:
            isPresent = false
        }
        return self
    }
}
