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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

extension CropUploadImageViewController {
    private func makeViews() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "シェア", style: .plain, target: nil, action: nil)
        imageView = UIImageView().apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.left.equalTo(view)
                make.width.lessThanOrEqualTo(view)
                make.height.lessThanOrEqualTo(view.snp.width)
            }
        }
        let textView = UITextView().apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.top.equalTo(imageView.snp.bottom).offset(12)
                make.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
                make.left.equalTo(view).offset(16)
                make.right.equalTo(view).offset(-16)
                make.height.greaterThanOrEqualTo(100)
            }
            this.textColor = .black
            this.font = .systemFont(ofSize: 14)
            this.isScrollEnabled = true
            this.textContainerInset = .zero
            this.textContainer.lineFragmentPadding = 0
        }
        connectKeyboardEvents(top: imageView, bottom: textView, bottomInset: 12, disposeBag: disposeBag)

        UILabel().apply { this in
            textView.addSubview(this)
            this.text = "概要を入力"
            this.font = textView.font
            this.textColor = .lightGray
            this.snp.makeConstraints { make in
                make.top.left.equalTo(textView)
            }
            textView.rx.text.asObservable()
                .map { $0?.count ?? 0 > 0 }
                .bind(to: this.rx.isHidden)
                .disposed(by: disposeBag)
        }
    }

    private func bindViewModel() {
        let input = CropUploadImageViewModel.Input(
            share: navigationItem.rightBarButtonItem!.rx.tap.map { _ in }
        )
        let output = viewModel.transform(input: input)
        output.croppedImage.asDriverOnErrorJustComplete().drive(imageView.rx.image).disposed(by: disposeBag)
        output.shared.asDriverOnErrorJustComplete().drive().disposed(by: disposeBag)
    }
}
