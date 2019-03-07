import UIKit
import SnapKit
import RxSwift
import RxCocoa

class StoryViewController: UIViewController {
    private let viewModel: HogeStoryViewModel
    private let disposeBag = DisposeBag()
    private var cancelLabel: UILabel!

    init(viewModel: HogeStoryViewModel) {
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

extension StoryViewController {
    private func makeViews() {
        view.backgroundColor = .white
        UILabel().apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.left.equalTo(view).inset(20)
                make.width.equalTo(view)
                make.height.equalTo(50)
            }
            this.textColor = .black
            this.backgroundColor = .white
            this.text = "hello"
        }
        cancelLabel = UILabel().apply { this in
            this.text = "キャンセル"
            this.textColor = .black
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelLabel)
    }

    private func bindViewModel() {
        let input = HogeStoryViewModel.Input(
            tapCancel: cancelLabel.rx.tapEvent.map{ _ in }
        )
        let output = viewModel.transform(input: input)
        output.canceled.asDriverOnErrorJustComplete().drive().disposed(by: disposeBag)
    }
}
