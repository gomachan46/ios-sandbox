import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CropUploadImageViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: CropUploadImageViewModel
    private var imageView: UIImageView!

    init(viewModel: CropUploadImageViewModel) {
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

extension CropUploadImageViewController {
    private func makeViews() {
        view.backgroundColor = .white
        imageView = UIImageView().apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide)
            }
        }
    }

    private func bindViewModel() {
        let input = CropUploadImageViewModel.Input()
        let output = viewModel.transform(input: input)
        output.croppedImage.asDriverOnErrorJustComplete().drive(imageView.rx.image).disposed(by: disposeBag)
    }
}