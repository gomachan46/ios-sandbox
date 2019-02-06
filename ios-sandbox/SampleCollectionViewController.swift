import UIKit
import SnapKit
import Kingfisher

class SampleCollectionViewController: UIViewController {
    private let minimumSpacing: CGFloat = 0.5
    private let columnCount = 3
    private var images: [UIImage?] = []
    private var urls: [URL] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout()).apply { this in
            view.addSubview(this)
            this.register(SampleCollectionViewCell.self, forCellWithReuseIdentifier: SampleCollectionViewCell.identifier)
            this.dataSource = self
            this.prefetchDataSource = self
            this.delegate = self
            this.backgroundColor = .white
        }
        // TODO: ひとつのAPIレスポンスみたいな形にしたい
        self.images = (1...30).map { _ in nil }
        self.urls = (1...30).map { _ in URL(string: "https://picsum.photos/300?image=\(Int.random(in: 1...100))")! }
    }

    private func fetchImage(indexPath: IndexPath) -> UIImage? {
        let url = self.urls[indexPath.row]
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                self.images[indexPath.row] = value.image
            case .failure(let error):
                print("Error: \(error)")
            }
        }

        return self.images[indexPath.row]
    }
}

extension SampleCollectionViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.urls.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SampleCollectionViewCell.identifier, for: indexPath) as! SampleCollectionViewCell
        if let image = self.images[indexPath.row] {
            cell.imageView.image = image
        } else {
            if let image = fetchImage(indexPath: indexPath) {
                cell.imageView.image = image
            }
        }
        return cell
    }
}

extension SampleCollectionViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = (self.view.frame.size.width / CGFloat(self.columnCount)) - self.minimumSpacing
        return CGSize(width: length, height: length)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.minimumSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.minimumSpacing
    }
}

extension SampleCollectionViewController: UICollectionViewDataSourcePrefetching {
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard let _ = self.images[indexPath.row] else {
                _ = fetchImage(indexPath: indexPath)
                continue
            }
        }
    }
}
