import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class TopicCollectionView: UICollectionView {
    private let topics: [Item]
    private let minimumSpacing: CGFloat = 1
    private let columnCount = 3
    private let disposeBag = DisposeBag()

    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, topics: [Item]) {
        self.topics = topics
        super.init(frame: frame, collectionViewLayout: layout)
        register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.identifier)
        register(StoriesView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: StoriesView.identifier)
        backgroundColor = .white
        dataSource = self
        delegate = self
        refreshControl = UIRefreshControl().apply { this in
            this.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TopicCollectionView {
    @objc private func refresh(sender: UIRefreshControl) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        DispatchQueue.global(qos: .userInteractive).async {
            Thread.sleep(forTimeInterval: 2.0)
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                sender.endRefreshing()
            }
        }
    }
}

extension TopicCollectionView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topics.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath)
        if let cell = cell as? ItemCollectionViewCell {
            cell.update(item: topics[indexPath.row])
        }

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: StoriesView.identifier, for: indexPath)

        return header
    }
}

extension TopicCollectionView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = (frame.width / CGFloat(columnCount)) - minimumSpacing
        return CGSize(width: length, height: length / 2 * 3)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: frame.width, height: 100)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumSpacing
    }
}
