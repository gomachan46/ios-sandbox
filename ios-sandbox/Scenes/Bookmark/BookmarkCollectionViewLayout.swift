import UIKit

protocol BookmarkCollectionViewLayoutDelegate {
    func cellHeight(collectionView: UICollectionView, indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat
}

class BookmarkCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var cellHeight: CGFloat = 0.0

    override func copy(with zone: NSZone?) -> Any {
        let copy = super.copy(with: zone) as! BookmarkCollectionViewLayoutAttributes
        copy.cellHeight = cellHeight

        return copy
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let attributes = object as? BookmarkCollectionViewLayoutAttributes, attributes.cellHeight == cellHeight else { return false }
        return super.isEqual(object)
    }
}

class BookmarkCollectionViewLayout: UICollectionViewLayout {
    var delegate: BookmarkCollectionViewLayoutDelegate?
    private var cache = [(attributes: BookmarkCollectionViewLayoutAttributes, height: CGFloat)]()

    private let numberOfColumn = 2
    private let cellMargin: CGFloat = 10.0
    private var contentHeight: CGFloat = 0.0
    private var contentWidth: CGFloat {
        return collectionView!.bounds.width - (collectionView!.contentInset.left + collectionView!.contentInset.right)
    }
    private var columnWidth: CGFloat {
        return contentWidth / CGFloat(numberOfColumn)
    }
    private var cellWidth: CGFloat {
        return columnWidth - (cellMargin * CGFloat(numberOfColumn - 1))
    }

    override func prepare() {
        super.prepare()
        guard let collectionView = self.collectionView, collectionView.numberOfSections > 0, let delegate = self.delegate else { return }

        var (xOffsets, yOffsets) = initXYOffsets()
        var columnIndex = 0

        (0..<collectionView.numberOfItems(inSection: 0)).forEach { item in
            func loopNext(height: CGFloat){
                yOffsets[columnIndex] = yOffsets[columnIndex] + height
                columnIndex = (columnIndex + 1) % numberOfColumn
            }

            if item < cache.count {
                loopNext(height: cache[item].height)
            } else {
                let indexPath = IndexPath(item: item, section: 0)
                let cellHeight = delegate.cellHeight(collectionView: collectionView, indexPath: indexPath, cellWidth: cellWidth)
                let rowHeight = (cellMargin * CGFloat(numberOfColumn - 1)) + CGFloat(cellHeight)
                let frame = CGRect(x: xOffsets[columnIndex], y: yOffsets[columnIndex], width: columnWidth, height: rowHeight)

                let attributes = BookmarkCollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.cellHeight = cellHeight
                attributes.frame = frame.insetBy(dx: cellMargin, dy: cellMargin)
                cache.append((attributes: attributes, height: rowHeight))
                contentHeight = max(contentHeight, frame.maxY)
                loopNext(height: rowHeight)
            }
        }
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.attributes.frame.intersects(rect) }.map{ $0.attributes }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForItem(at: indexPath)
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }

    private func initXYOffsets() -> ([CGFloat], [CGFloat]) {
        //x座標のオフセットの初期化
        var xOffsets = [CGFloat]()
        for column in 0 ..< numberOfColumn {
            xOffsets.append(CGFloat(column) * columnWidth)
        }
        //y座標のオフセットの初期化
        let yOffsets = [CGFloat](repeating: 0, count: numberOfColumn)

        return (xOffsets, yOffsets)
    }
}
