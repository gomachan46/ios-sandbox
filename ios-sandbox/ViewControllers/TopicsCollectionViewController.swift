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
    }
}
