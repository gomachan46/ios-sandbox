import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class TopicCollectionViewCell: UICollectionViewCell {
    private var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TopicCollectionViewCell {
    func setImage(from topic: Topic) {
        imageView.kf.setImage(with: topic.url)
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
