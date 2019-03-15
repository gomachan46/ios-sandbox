import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class BookMarkCollectionViewCell: UICollectionViewCell {
    private var imageView: UIImageView!
    private var keywordView: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BookMarkCollectionViewCell {
    func setAttributes(from bookMark: BookMark) {
        keywordView.text = bookMark.keyword
        keywordView.sizeToFit()
        imageView.kf.setImage(with: bookMark.url)
    }

    func height(cellWidth: CGFloat) -> CGFloat {
        if keywordView.text == nil {
            return cellWidth
        }

        let keywordHeight = keywordView.frame.height * (keywordView.frame.width / cellWidth)
        return cellWidth * 1.5 + keywordHeight
    }

    private func makeViews() {
        let stackView = UIStackView().apply { this in
            contentView.addSubview(this)
            this.axis = .vertical
            this.alignment = .fill
            this.distribution = .fill
            this.spacing = 5
            this.snp.makeConstraints { make in
                make.edges.equalTo(contentView)
            }
        }

        imageView = UIImageView().apply { this in
            stackView.addArrangedSubview(this)
            this.contentMode = .scaleAspectFill
            this.layer.masksToBounds = true
            this.layer.cornerRadius = 10
        }

        keywordView = UILabel().apply { this in
            stackView.addArrangedSubview(this)
            this.backgroundColor = .white
            this.textColor = .black
            this.numberOfLines = 0
            this.lineBreakMode = .byWordWrapping
        }
    }
}
