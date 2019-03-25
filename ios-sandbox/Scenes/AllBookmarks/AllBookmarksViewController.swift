import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher
import FloatingPanel

class AllBookmarksViewController: UIViewController {
    private let viewModel: AllBookmarksViewModel
    private var collectionView: AllBookmarksCollectionView!
    private let disposeBag = DisposeBag()
    private let fpcDelegate = SampleFloatingPanelControllerDelegate()
    private let fpc: FloatingPanelController

    init(viewModel: AllBookmarksViewModel) {
        fpc = FloatingPanelController(delegate: fpcDelegate)
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        let sampleNavigator = SampleNavigator()
        let sampleViewModel = SampleViewModel(navigator: sampleNavigator)
        let sampleViewController = SampleViewController(viewModel: sampleViewModel)
        fpc.surfaceView.cornerRadius = 24.0
        fpc.set(contentViewController: sampleViewController)
        fpc.addPanel(toParent: self)
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

extension AllBookmarksViewController {
    private func makeViews() {
        navigationItem.titleView = UILabel().apply { this in
            this.text = "ブックマーク"
            this.backgroundColor = .clear
            this.textColor = .black
        }
        collectionView = AllBookmarksCollectionView(frame: view.frame, collectionViewLayout: AllBookmarksCollectionViewLayout(), viewModel: viewModel).apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.edges.size.equalTo(view)
            }
        }
        collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:))))
    }

    private func bindViewModel() {
        let refreshTrigger = Observable.merge(
            rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).take(1).map { _ in }
        )
        let input = AllBookmarksViewModel.Input(refreshTrigger: refreshTrigger, selection: collectionView.rx.itemSelected.asObservable())
        let output = viewModel.transform(input: input)
        output.sectionOfBookmark.asDriverOnErrorJustComplete().drive(collectionView.rx.items(dataSource: collectionView.rxDataSource)).disposed(by: disposeBag)
        output.selectedBookmark.asDriverOnErrorJustComplete().drive().disposed(by: disposeBag)
    }

    private func selectedImageView() -> UIImageView {
        if let index = collectionView.indexPathsForSelectedItems?.first, let cell = collectionView.cellForItem(at: index) as? AllBookmarksCollectionViewCell {
            return cell.imageView
        }

        return UIImageView()
    }

    @objc private func handleLongPress(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            let point = recognizer.location(in: collectionView)
            let indexPath = collectionView.indexPathForItem(at: point)
            if let indexPath = indexPath {
                guard let cell = collectionView.cellForItem(at: indexPath) as? AllBookmarksCollectionViewCell else { break }
                fpc.move(to: .half, animated: true)
            }
        default:
            break
        }
    }
}

extension AllBookmarksViewController: ZoomTransitionSourceDelegate {
    public var animationDuration: TimeInterval {
        return 0.4
    }

    public func transitionImageView() -> UIImageView {
        return selectedImageView()
    }

    public func transitionImageViewFrame(forward: Bool) -> CGRect {
        return selectedImageView().convert(selectedImageView().bounds, to: view)
    }

    public func transitionSourceWillBegin() {
        selectedImageView().isHidden = true
    }

    public func transitionSourceDidEnd() {
        selectedImageView().isHidden = false
    }

    public func transitionSourceDidCancel() {
        selectedImageView().isHidden = false
    }
}
