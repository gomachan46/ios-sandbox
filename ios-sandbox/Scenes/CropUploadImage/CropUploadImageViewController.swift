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
        let stackView = UIStackView().apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.top.bottom.equalTo(view.safeAreaLayoutGuide)
                make.left.right.equalTo(view)
            }
            this.axis = .vertical
            this.alignment = .fill
            this.distribution = .fill
            this.spacing = 12
        }
        imageView = UIImageView().apply { this in
            stackView.addArrangedSubview(this)
            this.snp.makeConstraints { make in
                make.left.right.equalTo(view)
            }
        }
        let textView = UITextView().apply { this in
            stackView.addArrangedSubview(this)
            this.snp.makeConstraints { make in
                make.left.equalTo(stackView).inset(16)
                make.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
                make.height.greaterThanOrEqualTo(100)
            }
            this.textColor = .black
            this.font = .systemFont(ofSize: 14)
            this.isScrollEnabled = true
            this.textContainerInset = .zero
            this.textContainer.lineFragmentPadding = 0
            connectKeyboardEvents(to: this, bottomInset: 12, disposeBag: disposeBag)
        }

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
