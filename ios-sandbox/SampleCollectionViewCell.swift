import UIKit
import SnapKit
import Kingfisher

class SampleCollectionViewCell: UICollectionViewCell {
    static let identifier = "SampleCollectionViewCell"

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
        UIImageView().apply { this in
            self.contentView.addSubview(this)
            this.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            let url = URL(string: "https://picsum.photos/300?image=\(Int.random(in: 1...100))")
            this.kf.setImage(with: url)
        }
    }
}
