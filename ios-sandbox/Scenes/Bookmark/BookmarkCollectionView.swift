import UIKit
import RxSwift
import RxDataSources

class BookmarkCollectionView: UICollectionView {
    var rxDataSource: RxCollectionViewSectionedReloadDataSource<SectionOfBookmark>!
    private let viewModel: BookmarkViewModel

    init(frame: CGRect, collectionViewLayout layout: BookmarkCollectionViewLayout, viewModel: BookmarkViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame, collectionViewLayout: layout)
        rxDataSource = RxCollectionViewSectionedReloadDataSource<SectionOfBookmark>(
            configureCell: { dataSource, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkCollectionViewCell.reuseID, for: indexPath) as! BookmarkCollectionViewCell
                cell.setAttributes(from: item)
                return cell
            }
        )

        register(BookmarkCollectionViewCell.self, forCellWithReuseIdentifier: BookmarkCollectionViewCell.reuseID)
        backgroundColor = .white
        layout.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BookmarkCollectionView: BookmarkCollectionViewLayoutDelegate {
    func cellHeight(collectionView: UICollectionView, indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkCollectionViewCell.reuseID, for: indexPath) as? BookmarkCollectionViewCell else { return 0 }
        let item = rxDataSource[indexPath] as Bookmark
        cell.setKeyword(from: item)
        return cell.height(cellWidth: cellWidth)
    }
}
