import UIKit
import RxSwift
import RxDataSources

class BookMarkCollectionView: UICollectionView {
    var rxDataSource: RxCollectionViewSectionedReloadDataSource<SectionOfBookMark>!
    private let minimumSpacing: CGFloat = 1
    private let columnCount = 2
    private let viewModel: BookMarkViewModel

    init(frame: CGRect, collectionViewLayout layout: BookMarkCollectionViewLayout, viewModel: BookMarkViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame, collectionViewLayout: layout)
        rxDataSource = RxCollectionViewSectionedReloadDataSource<SectionOfBookMark>(
            configureCell: { dataSource, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookMarkCollectionViewCell.reuseID, for: indexPath) as! BookMarkCollectionViewCell
                cell.setImage(from: item)
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
        if indexPath.row % 3 == 0 {
            return 200
        }

        return 100.0
    }
}
