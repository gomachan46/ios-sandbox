import UIKit

class StoriesView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        let storiesScrollView = UIScrollView().apply { this in
            addSubview(this)
            this.snp.makeConstraints { make in
                make.edges.equalTo(self)
                make.height.equalTo(100)
            }
            this.showsVerticalScrollIndicator = false
            this.showsHorizontalScrollIndicator = false
        }
        let storiesStackView = UIStackView().apply { this in
            storiesScrollView.addSubview(this)
            this.axis = .horizontal
            this.alignment = .fill
            this.distribution = .fill
            this.spacing = 10

            this.snp.makeConstraints { make in
                make.edges.equalTo(storiesScrollView)
                make.height.equalTo(storiesScrollView)
            }
        }
        (1...10).forEach { _ in
            let storyView = UIView().apply { this in
                storiesStackView.addArrangedSubview(this)
            }
            let imageView = StoryImageView().apply { this in
                storyView.addSubview(this)
                this.kf.setImage(with: URL(string: "https://picsum.photos/100?image=\(Int.random(in: 1...100))"))
                this.snp.makeConstraints { make in
                    make.top.left.equalTo(storyView).inset(10)
                    make.right.equalTo(storyView).inset(10)
                    make.size.equalTo(60)
                }
            }
            UILabel().apply { this in
                storyView.addSubview(this)
                this.text = "ドリンクの作り方"
                this.font = .systemFont(ofSize: 12)
                this.textAlignment = .center
                this.snp.makeConstraints { make in
                    make.top.equalTo(imageView.snp.bottom)
                    make.centerX.equalTo(imageView)
                    make.width.equalTo(storyView)
                    make.height.equalTo(30)
                }
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
