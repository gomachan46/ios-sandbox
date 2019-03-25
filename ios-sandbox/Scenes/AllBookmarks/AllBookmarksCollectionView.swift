import UIKit
import RxSwift
import RxDataSources

class AllBookmarksCollectionView: UICollectionView {
    var rxDataSource: RxCollectionViewSectionedReloadDataSource<SectionOfBookmark>!
    private let viewModel: AllBookmarksViewModel

    init(frame: CGRect, collectionViewLayout layout: AllBookmarksCollectionViewLayout, viewModel: AllBookmarksViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame, collectionViewLayout: layout)
        rxDataSource = RxCollectionViewSectionedReloadDataSource<SectionOfBookmark>(
            configureCell: { _, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllBookmarksCollectionViewCell.reuseID, for: indexPath)
                if let cell = cell as? AllBookmarksCollectionViewCell {
                    cell.setAttributes(from: item)
                }
                return cell
        }
        )

        register(AllBookmarksCollectionViewCell.self, forCellWithReuseIdentifier: AllBookmarksCollectionViewCell.reuseID)
        backgroundColor = .white
        layout.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AllBookmarksCollectionView: AllBookmarksCollectionViewLayoutDelegate {
    func cellHeight(collectionView: UICollectionView, indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllBookmarksCollectionViewCell.reuseID, for: indexPath) as? AllBookmarksCollectionViewCell else { return 0 }
        let bookmark = rxDataSource[indexPath] as Bookmark
        cell.setAttributes(from: bookmark)
        return cell.height(from: bookmark, cellWidth: cellWidth)
    }
}
