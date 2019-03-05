import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TopicCollectionViewController: UIViewController {
    private let topics: [Item]
    private let disposeBag = DisposeBag()
    private var collectionView: UICollectionView!

    init(topics: [Item]) {
        self.topics = topics
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.titleView = UIImageView(image: R.image.navigationLogo_116x34()!)
        makeViews()
        setupViewModel()
    }
}

extension TopicCollectionViewController {
    private func makeViews() {
        collectionView = TopicCollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout(), topics: topics).apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.edges.size.equalTo(view)
            }
        }
    }

    private func setupViewModel() {
        collectionView
            .rx
            .itemSelected
            .subscribe(
                onNext: { indexPath in
                    let topic = self.topics[indexPath.row]
                    self.navigationController?.pushViewController(ItemViewController(item: topic), animated: true)
                }
            )
            .disposed(by: disposeBag)
    }
}
