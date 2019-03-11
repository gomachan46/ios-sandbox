import UIKit
import SnapKit

class SelectUploadImageCollectionViewController: UIViewController {
    var collectionView: SelectUploadImageCollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        makeViews()
        bindViewModel()
    }
}

extension SelectUploadImageCollectionViewController {
    private func makeViews() {
        collectionView = SelectUploadImageCollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout()).apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.edges.size.equalTo(view)
            }
        }
    }

    private func bindViewModel() {
    }
}
