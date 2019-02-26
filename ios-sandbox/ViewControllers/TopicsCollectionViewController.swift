import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TopicsCollectionViewController: UIViewController {
    private var items: [Item] = []
    private let disposeBag = DisposeBag()
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.titleView = UIImageView(image: R.image.navigationLogo_116x34()!)
        collectionView = TopicCollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout()).apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.edges.size.equalTo(view)
            }
        }
        items = (0..<30).map { _ in Item(username: "John", url: "https://picsum.photos/300?image=\(Int.random(in: 1...100))") }
        collectionView.rx.itemSelected.subscribe(onNext: { indexPath in
            let item = self.items[indexPath.row]
            self.navigationController?.pushViewController(ItemViewController(item: item), animated: true)
        })
        .disposed(by: disposeBag)

        let storiesScrollView = UIScrollView().apply { this in
            collectionView.addSubview(this)
            this.snp.makeConstraints { make in
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
}
