import UIKit
import SnapKit

class ViewController: UIViewController {
    var collectionView: UICollectionView!
    let minimumSpacing: CGFloat = 0.5
    let columnCount = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UICollectionView(
            frame: self.view.frame,
            collectionViewLayout: UICollectionViewFlowLayout().apply { layout in
                layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            }
        ).apply { this in
            view.addSubview(this)
            this.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
            this.dataSource = self
            this.delegate = self
            this.backgroundColor = .white
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .lightGray

        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = (self.view.frame.size.width / CGFloat(self.columnCount)) - self.minimumSpacing
        return CGSize(width: length, height: length)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.minimumSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.minimumSpacing
    }
}
