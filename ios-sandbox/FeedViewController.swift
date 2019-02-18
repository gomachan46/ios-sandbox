import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class FeedViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let scrollView = UIScrollView().apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.left.right.equalTo(view)
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
        (1...50).forEach { _ in
            let storyView = UIView().apply { this in
                stackView.addArrangedSubview(this)
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
}
