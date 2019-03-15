import UIKit
import RxSwift
import RxDataSources

class BookMarkCollectionView: UICollectionView {
    var rxDataSource: RxCollectionViewSectionedReloadDataSource<SectionOfBookMark>!
    private let viewModel: BookMarkViewModel

    init(frame: CGRect, collectionViewLayout layout: BookMarkCollectionViewLayout, viewModel: BookMarkViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame, collectionViewLayout: layout)
        rxDataSource = RxCollectionViewSectionedReloadDataSource<SectionOfBookMark>(
            configureCell: { dataSource, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookMarkCollectionViewCell.reuseID, for: indexPath) as! BookMarkCollectionViewCell
                cell.setAttributes(from: item)
                return cell
            }
        )

        register(BookMarkCollectionViewCell.self, forCellWithReuseIdentifier: BookMarkCollectionViewCell.reuseID)
        backgroundColor = .white
        layout.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BookMarkCollectionView: BookMarkCollectionViewLayoutDelegate {
    func cellHeight(collectionView: UICollectionView, indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookMarkCollectionViewCell.reuseID, for: indexPath) as? BookMarkCollectionViewCell else { return 0 }
        let item = rxDataSource[indexPath] as BookMark
        cell.setAttributes(from: item)

        return cell.height(cellWidth: cellWidth)
    }
}
