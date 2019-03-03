import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class TopicViewController: UIViewController {
    private let viewModel: TopicViewModel
    private let disposeBag = DisposeBag()
    private var imageView: UIImageView!

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
        imageView = UIImageView().apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.center.equalTo(view)
                make.width.equalTo(view)
                make.height.equalTo(view.snp.width)
            }
        }
    }

    private func bindViewModel() {
        let input = TopicViewModel.Input()
        let output = viewModel.transform(input: input)
        output
            .topic
            .asDriverOnErrorJustComplete()
            .drive(onNext: { topic in
                self.imageView.kf.setImage(with: URL(string: topic.url))
            })
            .disposed(by: disposeBag)
    }
}
