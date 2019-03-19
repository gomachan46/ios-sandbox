import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class BookmarkViewController: UIViewController {
    private let viewModel: BookmarkViewModel
    private var collectionView: BookmarkCollectionView!
    private let disposeBag = DisposeBag()

    init(viewModel: BookmarkViewModel) {
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

extension BookmarkViewController {
    private func makeViews() {
        navigationItem.titleView = UILabel().apply { this in
            this.text = "ブックマーク"
            this.backgroundColor = .clear
            this.textColor = .black
        }
        collectionView = BookmarkCollectionView(frame: view.frame, collectionViewLayout: BookmarkCollectionViewLayout(), viewModel: viewModel).apply { this in
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
        let input = BookmarkViewModel.Input(refreshTrigger: refreshTrigger)

        let output = viewModel.transform(input: input)
        output.sectionOfBookmark.asDriverOnErrorJustComplete().drive(collectionView.rx.items(dataSource: collectionView.rxDataSource)).disposed(by: disposeBag)
    }
}
