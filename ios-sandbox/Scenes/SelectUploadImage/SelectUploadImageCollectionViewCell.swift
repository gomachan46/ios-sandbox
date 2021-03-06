import UIKit
import SnapKit
import RxSwift
import Photos

class SelectUploadImageCollectionViewCell: UICollectionViewCell {
    private var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SelectUploadImageCollectionViewCell {
    func bind(_ photoAsset: PHAsset) {
        PHImageManager.default().requestImage(for: photoAsset, targetSize: frame.size, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            guard let image = image else { return }
            self.imageView.image = image
        })
    }

    private func makeViews() {
        imageView = UIImageView().apply { this in
            contentView.addSubview(this)
            this.snp.makeConstraints { make in
                make.edges.equalTo(contentView)
            }
        }
    }
}
