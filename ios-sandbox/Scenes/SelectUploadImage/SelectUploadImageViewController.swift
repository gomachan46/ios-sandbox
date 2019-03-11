import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Photos

class SelectUploadImageViewController: UIViewController {
    private let viewModel: SelectUploadImageViewModel
    private let disposeBag = DisposeBag()
    private var selectedImageView: SelectedUploadImageView!
    private var collectionView: SelectUploadImageCollectionView!
    private var cancelLabel: UILabel!

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
}

extension SelectUploadImageViewController {
    private func makeViews() {

        selectedImageView = SelectedUploadImageView(frame: view.frame).apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.left.right.equalTo(view)
                make.width.equalTo(view)
                make.height.equalTo(this.snp.width)
            }
        }

        let collectionViewController = SelectUploadImageCollectionViewController()
        addChild(collectionViewController)
        collectionViewController.view.apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.top.equalTo(selectedImageView.snp.bottom)
                make.left.right.bottom.width.equalTo(view)
                make.height.lessThanOrEqualTo(view)
            }
        }
        collectionViewController.didMove(toParent: self)
        collectionView = collectionViewController.collectionView

        title = "画像投稿"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        cancelLabel = UILabel().apply { this in
            this.text = "キャンセル"
            this.textColor = .black
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelLabel)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "次へ", style: .plain, target: nil, action: nil)
    }

    private func bindViewModel() {
        // TODO: 本当は2回トリガー引かずにrequestAuthorizationをうまくハンドリングしたいけどデフォルトの画像選択状態にするタイミングと合わせられなかったので渋々viewWillAppearのときもトリガーするようにしている
        let refreshTrigger = Observable.merge(
            rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).take(1).map { _ in },
            Observable.create { observer in
                PHPhotoLibrary.requestAuthorization { _ in observer.onNext(()) }
                return Disposables.create()
            }
        )
        let selection = Observable.merge(
            rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).take(1).map { _ in IndexPath(row: 0, section: 0) },
            collectionView.rx.itemSelected.asObservable()
        )
        let input = SelectUploadImageViewModel.Input(
            refreshTrigger: refreshTrigger,
            tapCancel: cancelLabel.rx.tapEvent.map{ _ in },
            selection: selection,
            tapNext: navigationItem.rightBarButtonItem!.rx.tap.map{ _ in self.cropImage() }
        )
        let output = viewModel.transform(input: input)
        output.sectionOfAlbums.asDriverOnErrorJustComplete().drive(collectionView.rx.items(dataSource: collectionView.rxDataSource)).disposed(by: disposeBag)
        output.canceled.asDriverOnErrorJustComplete().drive().disposed(by: disposeBag)
        output
            .selectedPhotoAsset
            .asDriverOnErrorJustComplete()
            .drive(onNext: { [unowned self] photoAsset in self.selectedImageView.bind(photoAsset) })
            .disposed(by: disposeBag)
        output.wentToNext.asDriverOnErrorJustComplete().drive().disposed(by: disposeBag)
    }

    private func cropImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(selectedImageView.frame.size, false, 0.0)
        selectedImageView.drawHierarchy(in: CGRect(origin: CGPoint(x: 0, y: 0), size: selectedImageView.frame.size), afterScreenUpdates: true)
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return croppedImage
    }
}
