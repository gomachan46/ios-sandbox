import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Photos
import FloatingPanel

class SelectUploadImageViewController: UIViewController {
    private let viewModel: SelectUploadImageViewModel
    private let disposeBag = DisposeBag()
    private var selectedImageView: SelectedUploadImageView!
    private var collectionView: SelectUploadImageCollectionView!
    private var cancelLabel: UILabel!
    private var fpc: FloatingPanelController!

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
        view.backgroundColor = .white
        selectedImageView = SelectedUploadImageView(frame: view.frame).apply { this in
            this.backgroundColor = .clear
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.left.right.equalTo(view)
                make.width.equalTo(view)
                make.height.equalTo(this.snp.width)
            }
        }

        let collectionViewController = SelectUploadImageCollectionViewController()
        fpc = FloatingPanelController()
        fpc.delegate = self
        fpc.set(contentViewController: collectionViewController)
        fpc.track(scrollView: collectionViewController.collectionView)
        fpc.addPanel(toParent: self)
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
            tapCancel: cancelLabel.rx.tapEvent.map { _ in },
            selection: selection,
            tapNext: navigationItem.rightBarButtonItem!.rx.tap.map { _ in self.cropImage() }
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
        collectionView.rx.itemSelected.asDriverOnErrorJustComplete().drive(onNext: { [unowned self] _ in self.fpc.move(to: .tip, animated: true)}).disposed(by: disposeBag)
    }

    private func cropImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(selectedImageView.frame.size, false, 0.0)
        selectedImageView.drawHierarchy(in: CGRect(origin: CGPoint(x: 0, y: 0), size: selectedImageView.frame.size), afterScreenUpdates: true)
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return croppedImage
    }
}

extension SelectUploadImageViewController: FloatingPanelControllerDelegate {
    public func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return SelectUploadImageFloatingPanelLayout()
    }

    public func floatingPanel(_ vc: FloatingPanelController, behaviorFor newCollection: UITraitCollection) -> FloatingPanelBehavior? {
        return SelectUploadImageFloatingPanelBehavior()
    }
}

class SelectUploadImageFloatingPanelLayout: FloatingPanelLayout {
    var initialPosition: FloatingPanelPosition {
        return .tip
    }
    var supportedPositions: Set<FloatingPanelPosition> {
        return [.full, .tip]
    }

    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return 56.0
        case .tip: return 200.0
        default: return nil
        }
    }
}

class SelectUploadImageFloatingPanelBehavior: FloatingPanelBehavior {

}
