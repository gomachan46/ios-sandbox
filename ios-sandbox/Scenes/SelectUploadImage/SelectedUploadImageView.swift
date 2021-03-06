import UIKit
import RxSwift
import Photos

class SelectedUploadImageView: UIScrollView {
    private var imageView: UIImageView!
    private let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        minimumZoomScale = 1.0
        maximumZoomScale = 8.0
        delegate = self
        makeViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SelectedUploadImageView {
    func bind(_ photoAsset: PHAsset) {
        PHImageManager.default().requestImage(for: photoAsset, targetSize: CGSize(width: 3000, height: 3000), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            guard let image = image else { return }
            self.imageView.image = image
            let wrate = self.frame.width / image.size.width
            let hrate = self.frame.height / image.size.height
            let rate = max(wrate, hrate)
            self.imageView.frame.size = CGSize(width: image.size.width * rate, height: image.size.height * rate)
            self.contentSize = self.imageView.frame.size
            self.updateScrollInset()
            self.setDefaultScale(image: image, animated: false)
        })
    }

    private func makeViews() {
        imageView = UIImageView().apply { this in
            addSubview(this)
            this.contentMode = .scaleAspectFit
            this.translatesAutoresizingMaskIntoConstraints = true
            this.rx.doubleTapEvent.subscribe(onNext: { _ in self.setDefaultScale(image: this.image, animated: true) }).disposed(by: disposeBag)
        }
    }
}

extension SelectedUploadImageView: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateScrollInset()
    }

    private func setDefaultScale(image: UIImage?, animated: Bool) {
        guard let image = image else { return }
        let width = image.size.width
        let height = image.size.height
        let scale = max(width / height, height / width)
        setZoomScale(scale, animated: animated)

        var center = CGPoint()
        center.x = (contentSize.width / 2.0) - (frame.width / 2.0)
        center.y = (contentSize.height / 2.0) - (frame.height / 2.0)
        setContentOffset(center, animated: animated)
    }

    private func updateScrollInset() {
        contentInset = UIEdgeInsets(
            top: max((frame.height - imageView.frame.height) / 2, 0),
            left: max((frame.width - imageView.frame.width) / 2, 0),
            bottom: 0,
            right: 0
        )
    }
}
