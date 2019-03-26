import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CropUploadImageViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: CropUploadImageViewModel
    private var imageView: UIImageView!
    private var textView: UITextView!
    private var textViewPlaceHolder: UILabel!
    private var textViewNumberOfCharacters: UILabel!

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
                make.left.equalTo(view)
                make.width.lessThanOrEqualTo(view)
                make.height.lessThanOrEqualTo(view.snp.width)
            }
        }
        textView = UITextView().apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.top.equalTo(imageView.snp.bottom).offset(12)
                make.left.equalTo(view).offset(16)
                make.right.equalTo(view).offset(-16)
                make.width.equalTo(view).offset(-32)
                make.height.greaterThanOrEqualTo(100)
            }
            this.textColor = .black
            this.font = .systemFont(ofSize: 14)
            this.isScrollEnabled = true
            this.textContainerInset = .zero
            this.textContainer.lineFragmentPadding = 0
        }

        textViewPlaceHolder = UILabel().apply { this in
            textView.addSubview(this)
            this.text = "概要を入力"
            this.font = textView.font
            this.textColor = .lightGray
            this.snp.makeConstraints { make in
                make.top.left.equalTo(textView)
            }
        }

        textViewNumberOfCharacters = UILabel().apply { this in
            view.addSubview(this)
            this.font = textView.font
            this.textColor = .black
            this.snp.makeConstraints { make in
                make.top.equalTo(textView.snp.bottom).offset(-20)
                make.left.equalTo(textView.snp.right).offset(-50)
            }
        }

        makeConstraintsWithKeyboard(top: imageView, bottom: textView, bottomInset: 12, disposeBag: disposeBag)
    }

    private func bindViewModel() {
        let input = CropUploadImageViewModel.Input(
            share: navigationItem.rightBarButtonItem!.rx.tap.map { _ in },
            currentText: textView.rx.text.asObservable()
        )

        let output = viewModel.transform(input: input)
        output.croppedImage.asDriverOnErrorJustComplete().drive(imageView.rx.image).disposed(by: disposeBag)
        output.shared.asDriverOnErrorJustComplete().drive().disposed(by: disposeBag)
        output.textViewPlaceHolderIsHidden.asDriverOnErrorJustComplete().drive(textViewPlaceHolder.rx.isHidden).disposed(by: disposeBag)
        output.textViewNumberOfCharactersText.asDriverOnErrorJustComplete().drive(textViewNumberOfCharacters.rx.text).disposed(by: disposeBag)
        output.textViewNumberOfCharactersTextColor.asDriverOnErrorJustComplete()
            .drive(onNext: { [unowned self] textColor in self.textViewNumberOfCharacters.textColor = textColor })
            .disposed(by: disposeBag)
    }
}
