import UIKit

protocol Reusable {
    static var reuseID: String {get}
}

extension Reusable {
    static var reuseID: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: Reusable {}

//extension UICollectionView {
//    func dequeueReusableCell<T>(ofType cellType: T.Type = T.self, at indexPath: IndexPath) -> T where T: UICollectionViewCell {
//        guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.reuseID, for: indexPath) as? T else {
//            fatalError()
//        }
//        return cell
//    }
//}
