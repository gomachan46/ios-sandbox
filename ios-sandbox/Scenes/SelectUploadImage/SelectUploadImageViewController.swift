import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class SelectUploadImageViewController: UIViewController {
    private let viewModel: SelectUploadImageViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: SelectUploadImageViewModel) {
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

extension SelectUploadImageViewController {
    private func makeViews() {
    }

    private func bindViewModel() {
        let input = SelectUploadImageViewModel.Input()
        let output = viewModel.transform(input: input)
    }
}
