import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class ItemViewController: UIViewController {
    private let item = BehaviorRelay<Item>(value: Item())
    private var pageView: UIPageControl!
    private let disposeBag = DisposeBag()
    private var scrollView: UIScrollView!

    init(item i: Item) {
        item.accept(i)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        let label = UILabel().apply { this in
            view.addSubview(this)
            this.text = item.value.username
            this.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.left.equalTo(view).inset(20)
                make.right.equalTo(view)
                make.height.equalTo(50)
            }
        }
        scrollView = UIScrollView().apply { this in
            view.addSubview(this)
            this.translatesAutoresizingMaskIntoConstraints = false
            this.snp.makeConstraints { make in
                make.top.equalTo(label.snp.bottom)
                make.left.right.equalToSuperview()
                make.width.equalTo(view)
                make.height.equalTo(this.snp.width)
            }
            this.isPagingEnabled = true
            this.showsHorizontalScrollIndicator = false
            this.showsVerticalScrollIndicator = false
            this.delegate = self
        }
        pageView = UIPageControl().apply { this in
            view.addSubview(this)
            this.pageIndicatorTintColor = .lightGray
            this.currentPageIndicatorTintColor = .black
            this.numberOfPages = 5
            this.currentPage = 0
            this.addTarget(self, action: #selector(self.tappedPageControl), for: .valueChanged)
            this.snp.makeConstraints { make in
                make.top.equalTo(scrollView.snp.bottom)
                make.left.right.equalTo(view)
                make.height.equalTo(50)
            }
        }
        let stackView = UIStackView().apply { this in
            scrollView.addSubview(this)
            this.axis = .horizontal
            this.alignment = .fill
            this.distribution = .fillEqually
            this.snp.makeConstraints { make in
                make.edges.height.equalTo(scrollView)
                make.width.equalTo(scrollView).multipliedBy(5)
            }
        }
        (1...5).forEach { _ in
            UIImageView().apply { this in
                stackView.addArrangedSubview(this)
                this.contentMode = .scaleAspectFill
                item.asDriver().drive(onNext: { _ in
                    this.kf.setImage(with: URL(string: "https://picsum.photos/300?image=\(Int.random(in: 1...100))"))
                })
                    .disposed(by: disposeBag)
                this.isUserInteractionEnabled = true
            }
        }
    }
}

extension ItemViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageView.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
    }

    @objc private func tappedPageControl() {
        var frame = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(pageView.currentPage)
        scrollView.scrollRectToVisible(frame, animated: true)
    }
}
