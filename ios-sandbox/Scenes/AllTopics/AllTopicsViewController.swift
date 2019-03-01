import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AllTopicsViewController: UIViewController {
    private let viewModel: AllTopicsViewModel
    private var collectionView: UICollectionView!
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
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout()).apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.left.equalTo(view)
                make.size.equalTo(view)
            }
            this.register(TopicCollectionViewCell.self, forCellWithReuseIdentifier: TopicCollectionViewCell.reuseID)
            this.backgroundColor = .white
        }
    }

    private func bindViewModel() {
        let input = AllTopicsViewModel.Input()
        let output = viewModel.transform(input: input)
        output.topics.drive(collectionView.rx.items(cellIdentifier: TopicCollectionViewCell.reuseID, cellType: TopicCollectionViewCell.self)) { cv, viewModel, cell in
            cell.bind(viewModel)
        }.disposed(by: disposeBag)
    }
}
