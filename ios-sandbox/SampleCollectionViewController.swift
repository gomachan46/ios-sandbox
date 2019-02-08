import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SampleCollectionViewController: UIViewController {
    private let minimumSpacing: CGFloat = 0.5
    private let columnCount = 3
    private var items: [SampleItem] = []
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.titleView = UIImageView(image: R.image.navigationLogo_116x34()!)
        items = (0..<30).map { _ in SampleItem(url: "https://picsum.photos/300?image=\(Int.random(in: 1...100))") }
        UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout()).apply { this in
            view.addSubview(this)
            this.register(SampleCollectionViewCell.self, forCellWithReuseIdentifier: SampleCollectionViewCell.identifier)
            this.dataSource = self
            this.delegate = self
            this.backgroundColor = .white
            this.rx.itemSelected
                .subscribe(onNext: { indexPath in
                    let item = self.items[indexPath.row]
                    self.navigationController?.pushViewController(SampleItemViewController(item: item), animated: true)
                })
                .disposed(by: disposeBag)
        }
    }
}

extension SampleCollectionViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SampleCollectionViewCell.identifier, for: indexPath) as! SampleCollectionViewCell
        cell.update(item: items[indexPath.row])
        return cell
    }
}

extension SampleCollectionViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = (view.frame.size.width / CGFloat(columnCount)) - minimumSpacing
        return CGSize(width: length, height: length)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumSpacing
    }
}
