import UIKit
import RxSwift
import RxCocoa

class StoriesHeaderView: UICollectionReusableView {
    private var stackView: UIStackView!
    private var viewModel: StoriesViewModel!
    private let disposeBag = DisposeBag()

    override var layer: CALayer {
        let layer = super.layer
        layer.zPosition = 0
        return layer
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        let scrollView = UIScrollView().apply { this in
            addSubview(this)
            this.snp.makeConstraints { make in
                make.edges.equalTo(self)
                make.height.equalTo(100)
            }
            this.showsVerticalScrollIndicator = false
            this.showsHorizontalScrollIndicator = false
        }
        stackView = UIStackView().apply { this in
            scrollView.addSubview(this)
            this.axis = .horizontal
            this.alignment = .fill
            this.distribution = .fill
            this.spacing = 10

            this.snp.makeConstraints { make in
                make.edges.equalTo(scrollView)
                make.height.equalTo(scrollView)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StoriesHeaderView {
    func bind(_ viewModel: StoriesViewModel) {
        self.viewModel = viewModel
        let input = StoriesViewModel.Input()
        let output = viewModel.transform(input: input)
        output.stories
            .asDriverOnErrorJustComplete()
            .drive(onNext: { stories in
                self.stackView.arrangedSubviews.forEach { subview in
                    self.stackView.removeArrangedSubview(subview)
                    NSLayoutConstraint.deactivate(subview.constraints)
                    subview.removeFromSuperview()
                }
                stories.forEach { story in
                    StoryView(frame: self.frame, viewModel: StoryViewModel(navigator: viewModel.navigator, story: story)).apply { this in
                        self.stackView.addArrangedSubview(this)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}
