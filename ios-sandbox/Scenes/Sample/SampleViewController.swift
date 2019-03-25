import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class SampleViewController: UIViewController {
    private let viewModel: SampleViewModel
    private let disposeBag = DisposeBag()
    private var userLabel: UILabel!

    init(viewModel: SampleViewModel) {
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

extension SampleViewController {
    private func makeViews() {
        view.backgroundColor = .white
        userLabel = UILabel().apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.center.equalTo(view)
            }
            this.textColor = .black
            this.backgroundColor = .white
            this.text = "hello"
        }
    }

    private func bindViewModel() {
        let input = SampleViewModel.Input()
        let output = viewModel.transform(input: input)
    }
}
