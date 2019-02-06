import UIKit
import SnapKit

class SampleCollectionViewController: UIViewController {
    private let minimumSpacing: CGFloat = 0.5
    private let columnCount = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout()).apply { this in
            view.addSubview(this)
            this.register(SampleCollectionViewCell.self, forCellWithReuseIdentifier: SampleCollectionViewCell.identifier)
            this.dataSource = self
            this.delegate = self
            this.backgroundColor = .white
        }
    }
}

extension SampleCollectionViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SampleCollectionViewCell.identifier, for: indexPath) as! SampleCollectionViewCell
        return cell
    }
}

extension SampleCollectionViewController: UICollectionViewDelegateFlowLayout {
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
