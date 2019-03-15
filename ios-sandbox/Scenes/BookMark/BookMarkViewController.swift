import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class BookMarkViewController: UIViewController {
    private let viewModel: BookMarkViewModel
    private var collectionView: BookMarkCollectionView!
    private let disposeBag = DisposeBag()

    init(viewModel: BookMarkViewModel) {
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

extension BookMarkViewController {
    private func makeViews() {
        navigationItem.titleView = UILabel().apply { this in
            this.text = "ブックマーク"
            this.backgroundColor = .clear
            this.textColor = .black
        }
        collectionView = BookMarkCollectionView(frame: view.frame, collectionViewLayout: BookMarkCollectionViewLayout(), viewModel: viewModel).apply { this in
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
        let input = BookMarkViewModel.Input(refreshTrigger: refreshTrigger)

        let output = viewModel.transform(input: input)
        output.sectionOfBookMark.asDriverOnErrorJustComplete().drive(collectionView.rx.items(dataSource: collectionView.rxDataSource)).disposed(by: disposeBag)
    }
}
