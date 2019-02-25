import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Photos

class ImageCropController: UIViewController {
    private var image: UIImage!
    private let disposeBag = DisposeBag()

    init(image i: UIImage) {
        image = i
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let stackView = UIStackView().apply { this in
            view.addSubview(this)
            this.axis = .vertical
            this.alignment = .center
            this.distribution = .equalSpacing
            this.spacing = 10
            this.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
                make.left.equalTo(view).offset(10)
                make.right.equalTo(view).offset(-10)
            }
        }
        UIImageView(image: image).apply { this in
            stackView.addArrangedSubview(this)
            this.snp.makeConstraints { make in
                make.width.equalTo(image.size.width / 2)
                make.height.equalTo(image.size.height / 2)
            }
        }
        UIView().apply { this in
            stackView.addArrangedSubview(this)
            this.backgroundColor = .lightGray
            this.snp.makeConstraints { make in
                make.width.equalTo(stackView)
                make.height.equalTo(1)
            }
        }
        let caption = UITextView().apply { this in
            stackView.addArrangedSubview(this)
            this.snp.makeConstraints { make in
                make.width.equalTo(stackView)
                make.height.equalTo(view).dividedBy(5)
            }
            this.textColor = .black
        }
        UILabel().apply { this in
            caption.addSubview(this)
            this.text = "キャプションを書く"
            this.font = caption.font
            this.textColor = .lightGray
            this.snp.makeConstraints { make in
                make.top.left.equalTo(caption).inset(5)
            }
            caption.rx.text.asObservable()
                .map { $0?.count ?? 0 > 0 }
                .bind(to: this.rx.isHidden)
                .disposed(by: disposeBag)
        }
        UIView().apply { this in
            stackView.addArrangedSubview(this)
            this.backgroundColor = .lightGray
            this.snp.makeConstraints { make in
                make.width.equalTo(stackView)
                make.height.equalTo(1)
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}
