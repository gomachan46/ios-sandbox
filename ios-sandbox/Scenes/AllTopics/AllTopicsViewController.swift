import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AllTopicsViewController: UIViewController {
    private let viewModel: AllTopicsViewModel
    private var collectionView: AllTopicsCollectionView!
    private let disposeBag = DisposeBag()

    init(viewModel: AllTopicsViewModel) {
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

extension AllTopicsViewController {
    private func makeViews() {
        collectionView = AllTopicsCollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout()).apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.edges.size.equalTo(view)
            }
        }
    }

    private func bindViewModel() {
        let refreshTrigger = Observable.merge(
            rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).take(1).map { _ in },
            collectionView.refreshControl!.rx.controlEvent(.valueChanged).asObservable()
        )

        let input = AllTopicsViewModel.Input(
            selection: collectionView.rx.itemSelected.asObservable(),
            refreshTrigger: refreshTrigger
        )

        let output = viewModel.transform(input: input)
        output.sectionOfTopics.asDriverOnErrorJustComplete().drive(collectionView.rx.items(dataSource: collectionView.rxDataSource)).disposed(by: disposeBag)
        output.selectedTopic.asDriverOnErrorJustComplete().drive().disposed(by: disposeBag)
        output.isFetching.asDriverOnErrorJustComplete().drive(collectionView.refreshControl!.rx.isRefreshing).disposed(by: disposeBag)
    }
}
