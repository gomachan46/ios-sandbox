import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class AllBookmarksViewController: UIViewController {
    private let viewModel: AllBookmarksViewModel
    private var collectionView: AllBookmarksCollectionView!
    private let disposeBag = DisposeBag()

    init(viewModel: AllBookmarksViewModel) {
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
}

extension AllBookmarksViewController: ZoomTransitioningSource
{
    var imageView: UIImageView {
        if let index = collectionView?.indexPathsForSelectedItems?.first, let cell = collectionView?.cellForItem(at: index) as? AllBookmarksCollectionViewCell {
            return cell.imageView
        }
        return UIImageView()
    }
}
