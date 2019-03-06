import UIKit
import RxDataSources

class SelectUploadImageCollectionView: UICollectionView {
    let rxDataSource: RxCollectionViewSectionedReloadDataSource<SectionOfAlbum>
    private let minimumSpacing: CGFloat = 1
    private let columnCount = 4

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        rxDataSource = RxCollectionViewSectionedReloadDataSource<SectionOfAlbum>(
            configureCell: { dataSource, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectUploadImageCollectionViewCell.reuseID, for: indexPath) as! SelectUploadImageCollectionViewCell
                cell.bind(item)
                return cell
            })
        super.init(frame: frame, collectionViewLayout: layout)

        register(SelectUploadImageCollectionViewCell.self, forCellWithReuseIdentifier: SelectUploadImageCollectionViewCell.reuseID)
        backgroundColor = .white
        delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SelectUploadImageCollectionView : UICollectionViewDelegateFlowLayout {
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
