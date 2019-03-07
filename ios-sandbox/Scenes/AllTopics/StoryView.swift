import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class StoryView: UIView {
    private let viewModel: StoryViewModel
    private var imageView: UIImageView!
    private var label: UILabel!
    private let disposeBag = DisposeBag()

    init(frame: CGRect, viewModel: StoryViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        makeViews()
        bindViewModel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StoryView {
    private func makeViews() {
        imageView = StoryImageView().apply { this in
            addSubview(this)
            this.snp.makeConstraints { make in
                make.top.left.equalTo(self).inset(10)
                make.right.equalTo(self).inset(10)
                make.size.equalTo(60)
            }
        }
        label = UILabel().apply { this in
            addSubview(this)
            this.font = .systemFont(ofSize: 12)
            this.textAlignment = .center
            this.snp.makeConstraints { make in
                make.top.equalTo(imageView.snp.bottom)
                make.centerX.equalTo(imageView)
                make.width.equalTo(self)
                make.height.equalTo(30)
            }
        }
    }

    private func bindViewModel() {
        let input = StoryViewModel.Input(
            selection: rx.tapEvent.map { _ in }
        )
        let output = viewModel.transform(input: input)
        output
            .url
            .asDriverOnErrorJustComplete()
            .drive(onNext: { [unowned self] url in self.imageView.kf.setImage(with: url) })
            .disposed(by: disposeBag)
        output.title.asDriverOnErrorJustComplete().drive(label.rx.text).disposed(by: disposeBag)
        output.selectedStory.asDriverOnErrorJustComplete().drive().disposed(by: disposeBag)
    }
}
