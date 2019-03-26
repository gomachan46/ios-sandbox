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
    private var submitButton: UIButton!

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
                make.left.right.equalTo(view)
                make.width.equalTo(view)
                make.height.equalTo(this.snp.width)
            }
            this.contentMode = .scaleAspectFill
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
            this.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
            this.font = .systemFont(ofSize: 14)
            this.isScrollEnabled = true
            this.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            this.textContainer.lineFragmentPadding = 5.0
            this.layer.cornerRadius = 8
        }

        textViewPlaceHolder = UILabel().apply { this in
            textView.addSubview(this)
            this.text = "概要を入力"
            this.font = textView.font
            this.textColor = .lightGray
            this.snp.makeConstraints { make in
                make.top.left.equalTo(textView).inset(8)
            }
        }

        textViewNumberOfCharacters = UILabel().apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.top.equalTo(textView.snp.bottom).offset(-25)
                make.left.equalTo(textView.snp.right).offset(-65)
            }
            this.font = textView.font
            this.textColor = .black
        }

        submitButton = UIButton().apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.top.equalTo(textView.snp.bottom).offset(100)
                make.left.equalTo(textView)
                make.width.equalTo(textView)
                make.height.equalTo(70)
            }
            this.setTitle("応募", for: .normal)
            this.setTitleColor(.white, for: .normal)
            this.layer.cornerRadius = 8
        }

        makeConstraintsWithKeyboard(top: imageView, bottom: submitButton, bottomInset: 12, disposeBag: disposeBag)
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
        output.submitButtonIsEnabled.asDriverOnErrorJustComplete().drive(submitButton.rx.isEnabled).disposed(by: disposeBag)
        output.submitButtonBackgroundColor.asDriverOnErrorJustComplete()
            .drive(onNext: { color in
                UIView.animate(withDuration: 0.3, animations: { [unowned self] in self.submitButton.backgroundColor = color })
            })
            .disposed(by: disposeBag)
    }
}
