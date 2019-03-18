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
        setKeyword(from: bookMark)
        setImage(from: bookMark)
    }

    func setImage(from bookMark: BookMark) {
        imageView.kf.setImage(with: bookMark.url)
    }

    func setKeyword(from bookMark: BookMark) {
        keywordView.text = bookMark.keyword
        keywordView.sizeToFit()
    }

    func height(cellWidth: CGFloat) -> CGFloat {
        if keywordView.text == nil {
            return cellWidth
        }

        return cellWidth * 1.5
    }

    private func makeViews() {
        imageView = UIImageView().apply { this in
            contentView.addSubview(this)
            this.snp.makeConstraints { make in
                make.size.edges.equalTo(contentView)
            }
            this.contentMode = .scaleAspectFill
            this.layer.masksToBounds = true
            this.layer.cornerRadius = 10
        }

        keywordView = UILabel().apply { this in
            contentView.addSubview(this)
            this.snp.makeConstraints { make in
                make.bottom.equalTo(imageView).offset(-15)
                make.left.right.width.equalTo(contentView)
            }
            this.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
            this.textColor = .black
            this.numberOfLines = 0
            this.lineBreakMode = .byWordWrapping
        }
    }
}
