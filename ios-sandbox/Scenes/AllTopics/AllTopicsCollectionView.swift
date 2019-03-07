import UIKit
import RxSwift
import RxDataSources

class AllTopicsCollectionView: UICollectionView {
    var rxDataSource: RxCollectionViewSectionedReloadDataSource<SectionOfTopic>!
    private let minimumSpacing: CGFloat = 1
    private let columnCount = 3

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        rxDataSource = RxCollectionViewSectionedReloadDataSource<SectionOfTopic>(
            configureCell: { dataSource, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCollectionViewCell.reuseID, for: indexPath) as! TopicCollectionViewCell
                cell.setImage(from: item)
                return cell
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: StoriesHeaderView.reuseID, for: indexPath) as! StoriesHeaderView
                let storiesViewModel = StoriesViewModel()
                header.bind(storiesViewModel)
                return header
            }
        )

        register(TopicCollectionViewCell.self, forCellWithReuseIdentifier: TopicCollectionViewCell.reuseID)
        register(StoriesHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: StoriesHeaderView.reuseID)
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
