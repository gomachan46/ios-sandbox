import UIKit
import SnapKit

class SampleCollectionViewCell: UICollectionViewCell {
    static let identifier = "SampleCollectionViewCell"
    var imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SampleCollectionViewCell {
    private func makeViews() {
        self.contentView.backgroundColor = .lightGray
        imageView.apply { this in
            self.contentView.addSubview(this)
            this.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
}
