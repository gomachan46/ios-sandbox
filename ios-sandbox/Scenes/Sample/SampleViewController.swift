import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class SampleViewController: UIViewController {
    private let viewModel: SampleViewModel
    private let disposeBag = DisposeBag()

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
        UILabel().apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.top.equalTo(view).offset(100)
                make.centerX.equalTo(view)
            }
            this.textColor = .black
            this.backgroundColor = .white
            this.text = ":)"
        }
        UILabel().apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.bottom.equalTo(view).offset(-100)
                make.centerX.equalTo(view)
            }
            this.textColor = .black
            this.backgroundColor = .white
            this.text = ":) :)"
        }
    }

    private func bindViewModel() {
        let input = SampleViewModel.Input()
        let output = viewModel.transform(input: input)
    }
}
