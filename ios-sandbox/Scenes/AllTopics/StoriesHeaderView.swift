import UIKit

class StoriesHeaderView: UICollectionReusableView {
    override var layer: CALayer {
        let layer = super.layer
        layer.zPosition = 0
        return layer
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        let scrollView = UIScrollView().apply { this in
            addSubview(this)
            this.snp.makeConstraints { make in
                make.edges.equalTo(self)
                make.height.equalTo(100)
            }
            this.showsVerticalScrollIndicator = false
            this.showsHorizontalScrollIndicator = false
        }
        let stackView = UIStackView().apply { this in
            scrollView.addSubview(this)
            this.axis = .horizontal
            this.alignment = .fill
            this.distribution = .fill
            this.spacing = 10

            this.snp.makeConstraints { make in
                make.edges.equalTo(scrollView)
                make.height.equalTo(scrollView)
            }
        }
        (1...10).forEach { _ in
            StoryView().apply { this in
                stackView.addArrangedSubview(this)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
