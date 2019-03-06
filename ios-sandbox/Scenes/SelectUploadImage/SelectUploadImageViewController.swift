import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher
import Photos

class SelectUploadImageViewController: UIViewController {
    private let viewModel: SelectUploadImageViewModel
    private let disposeBag = DisposeBag()
    private var collectionView: SelectUploadImageCollectionView!

    init(viewModel: SelectUploadImageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeViews()
        bindViewModel()
    }

    @objc func viewWillEnterForeground(_ notification: Notification?) {
        if (self.isViewLoaded && (self.view.window != nil)) {

        }
    }
}

extension SelectUploadImageViewController {
    private func makeViews() {
        collectionView = SelectUploadImageCollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout()).apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.edges.size.equalTo(view)
            }
        }
    }

    private func bindViewModel() {
        let input = SelectUploadImageViewModel.Input(
            refreshTrigger: Observable.create { observer in
                PHPhotoLibrary.requestAuthorization { _ in observer.onNext(()) }
                return Disposables.create()
            }
        )
        let output = viewModel.transform(input: input)
        output.sectionOfAlbums.asDriverOnErrorJustComplete().drive(collectionView.rx.items(dataSource: collectionView.rxDataSource)).disposed(by: disposeBag)
    }
}
