import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class TopicViewController: UIViewController {
    private let viewModel: TopicViewModel
    private let disposeBag = DisposeBag()
    private var imageView: UIImageView!
    private var userLabel: UILabel!

    init(viewModel: TopicViewModel) {
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

extension TopicViewController {
    private func makeViews() {
        view.backgroundColor = .white
        userLabel = UILabel().apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.left.equalTo(view).inset(20)
                make.width.equalTo(view)
                make.height.equalTo(50)
            }
            this.textColor = .black
            this.backgroundColor = .white
        }
        imageView = UIImageView().apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.top.equalTo(userLabel.snp.bottom)
                make.left.right.equalTo(view)
                make.width.equalTo(view)
                make.height.equalTo(view.snp.width)
            }
            this.contentMode = .scaleAspectFill
        }
    }

    private func bindViewModel() {
        let input = TopicViewModel.Input()
        let output = viewModel.transform(input: input)
        output
            .url
            .asDriverOnErrorJustComplete()
            .drive(onNext: { [unowned self] url in self.imageView.kf.setImage(with: url) })
            .disposed(by: disposeBag)
        output.username.asDriverOnErrorJustComplete().drive(userLabel.rx.text).disposed(by: disposeBag)
    }
}

extension TopicViewController: ZoomTransitionDestinationDelegate {
    public func transitionImageView() -> UIImageView {
        return imageView
    }

    func transitionImageViewFrame(forward: Bool) -> CGRect {
        view.layoutIfNeeded()
        return imageView.convert(imageView.bounds, to: view)
    }

    func transitionDestinationWillBegin() {
        imageView.isHidden = true
    }

    func transitionDestinationDidEnd(transitioningImageView imageView: UIImageView) {
        self.imageView.isHidden = false
        self.imageView.image = imageView.image
    }

    func transitionDestinationDidCancel() {
        imageView.isHidden = false
    }
}
