import UIKit
import RxSwift
import RxDataSources

class BookMarkCollectionView: UICollectionView {
    var rxDataSource: RxCollectionViewSectionedReloadDataSource<SectionOfBookMark>!
    private let minimumSpacing: CGFloat = 1
    private let columnCount = 2
    private let viewModel: BookMarkViewModel

    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, viewModel: BookMarkViewModel) {
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
        delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BookMarkCollectionView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = (frame.width / CGFloat(columnCount)) - minimumSpacing
        return CGSize(width: length, height: length)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumSpacing
    }
}
