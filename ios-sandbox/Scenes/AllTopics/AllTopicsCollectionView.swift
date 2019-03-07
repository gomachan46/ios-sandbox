import UIKit
import RxDataSources

class AllTopicsCollectionView: UICollectionView {
    private let minimumSpacing: CGFloat = 1
    private let columnCount = 3
    let rxDataSource: RxCollectionViewSectionedReloadDataSource<SectionOfTopic>

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        rxDataSource = RxCollectionViewSectionedReloadDataSource<SectionOfTopic>(
            configureCell: { dataSource, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCollectionViewCell.reuseID, for: indexPath) as! TopicCollectionViewCell
                cell.bind(item)
                return cell
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: StoriesView.reuseID, for: indexPath)
                return header
            }
        )
        super.init(frame: frame, collectionViewLayout: layout)

        register(TopicCollectionViewCell.self, forCellWithReuseIdentifier: TopicCollectionViewCell.reuseID)
        register(StoriesView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: StoriesView.reuseID)
        backgroundColor = .white
        delegate = self
        refreshControl = UIRefreshControl()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AllTopicsCollectionView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = (frame.width / CGFloat(columnCount)) - minimumSpacing
        return CGSize(width: length, height: length)
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
