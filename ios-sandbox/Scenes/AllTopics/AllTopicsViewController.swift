import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator

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
        collectionView = AllTopicsCollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout())
    }

    private func bindViewModel() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfTopic>(
            configureCell: { dataSource, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicCollectionViewCell.reuseID, for: indexPath) as! TopicCollectionViewCell
                cell.bind(item)
                return cell
            })
        collectionView.dataSource = dataSource

        let input = AllTopicsViewModel.Input()
        let output = viewModel.transform(input: input)
        output.topics.drive(collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
}
