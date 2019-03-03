import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator

class TopicViewController: UIViewController {
    private let viewModel: TopicViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: TopicViewModel) {
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

extension TopicViewController {
    private func makeViews() {
        view.backgroundColor = .white
        UILabel().apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.center.equalTo(view)
            }
            this.text = "hello"
            this.textColor = .black
        }
    }

    private func bindViewModel() {
        let input = TopicViewModel.Input()
        let output = viewModel.transform(input: input)
    }
}
