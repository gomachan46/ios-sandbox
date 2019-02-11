import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class ItemViewController: UIViewController {
    private var scrollView: UIScrollView!
    private var pageView: UIPageControl!
    private var itemZoomViewControllers: [ItemZoomViewController]!
    private let item = BehaviorRelay<Item>(value: Item())
    private let disposeBag = DisposeBag()

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
                make.left.equalToSuperview().inset(20)
                make.right.equalToSuperview()
                make.height.equalTo(50)
            }
        }
        scrollView = UIScrollView().apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.top.equalTo(label.snp.bottom)
                make.left.right.equalToSuperview()
                make.width.equalToSuperview()
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
            this.snp.makeConstraints { make in
                make.top.equalTo(scrollView.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(50)
            }
        }
        let stackView = UIStackView().apply { this in
            scrollView.addSubview(this)
            this.axis = .horizontal
            this.alignment = .fill
            this.distribution = .fill
            this.snp.makeConstraints { make in
                make.edges.height.equalToSuperview()
            }
        }
        itemZoomViewControllers = (1...5).map { _ in
            let vc = ItemZoomViewController(item: item.value)
            return vc
        }
        itemZoomViewControllers.forEach { vc in
            stackView.addArrangedSubview(vc.view)
        }
    }
}

extension ItemViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageView.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
}
