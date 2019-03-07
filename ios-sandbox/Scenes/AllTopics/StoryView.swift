import UIKit

class StoryView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let imageView = StoryImageView().apply { this in
            addSubview(this)
            this.kf.setImage(with: URL(string: "https://picsum.photos/100?image=\(Int.random(in: 1...100))"))
            this.snp.makeConstraints { make in
                make.top.left.equalTo(self).inset(10)
                make.right.equalTo(self).inset(10)
                make.size.equalTo(60)
            }
        }
        UILabel().apply { this in
            addSubview(this)
            this.text = "ドリンクの作り方"
            this.font = .systemFont(ofSize: 12)
            this.textAlignment = .center
            this.snp.makeConstraints { make in
                make.top.equalTo(imageView.snp.bottom)
                make.centerX.equalTo(imageView)
                make.width.equalTo(self)
                make.height.equalTo(30)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
