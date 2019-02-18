import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ItemCollectionViewController: UIViewController {
    private let minimumSpacing: CGFloat = 1
    private let columnCount = 3
    private var items: [Item] = []
    private let disposeBag = DisposeBag()
    private var collectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.titleView = UIImageView(image: R.image.navigationLogo_116x34()!)
        items = (0..<30).map { _ in Item(username: "John", url: "https://picsum.photos/300?image=\(Int.random(in: 1...100))") }
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout()).apply { this in
            view.addSubview(this)
            this.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.identifier)
            this.dataSource = self
            this.delegate = self
            this.backgroundColor = .white
            this.rx.itemSelected
                .subscribe(onNext: { indexPath in
                    let item = self.items[indexPath.row]
                    self.navigationController?.pushViewController(ItemViewController(item: item), animated: true)
                })
                .disposed(by: disposeBag)
        }
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
    }
}

extension ItemCollectionViewController {
    @objc private func refresh(sender: UIRefreshControl) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        DispatchQueue.global(qos: .userInteractive).async {
            Thread.sleep(forTimeInterval: 2.0)
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.refreshControl.endRefreshing()
            }
        }
    }
}

extension ItemCollectionViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as! ItemCollectionViewCell
        cell.update(item: items[indexPath.row])
        return cell
    }
}

extension ItemCollectionViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = (view.frame.width / CGFloat(columnCount)) - minimumSpacing
        return CGSize(width: length, height: length)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumSpacing
    }
}
