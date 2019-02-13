import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class ItemViewController: UIViewController {
    private var scrollView: UIScrollView!
    private var pageView: UIPageControl!
    private var label: UILabel!
    private let item = BehaviorRelay<Item>(value: Item())
    private let disposeBag = DisposeBag()
    private let imageTag = 1
    private var backgroundAlpha: CGFloat = 1.0

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
        label = UILabel().apply { this in
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
        let stackView = UIStackView().apply { this in
            scrollView.addSubview(this)
            this.axis = .horizontal
            this.alignment = .fill
            this.distribution = .fill
            this.snp.makeConstraints { make in
                make.edges.height.equalToSuperview()
            }
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
        (1...5).forEach { _ in
            let pageScrollView = UIScrollView().apply { this in
                stackView.addArrangedSubview(this)
                this.snp.makeConstraints { make in
                    make.size.equalTo(scrollView)
                }
                this.showsHorizontalScrollIndicator = false
                this.showsVerticalScrollIndicator = false
                this.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGesture(_:))))
            }
            UIImageView().apply { this in
                pageScrollView.addSubview(this)
                this.tag = imageTag
                this.snp.makeConstraints { make in
                    make.size.equalTo(scrollView)
                }
                this.contentMode = .scaleAspectFit
                item.asDriver().drive(onNext: { item in
                        this.kf.setImage(with: URL(string: "https://picsum.photos/300?image=\(Int.random(in: 1...100))"))
                    })
                    .disposed(by: disposeBag)
            }
        }
    }
}

extension ItemViewController {
    @objc func pinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard let zoomingView = gestureRecognizer.view else { return }
        switch gestureRecognizer.state {
        case .began, .changed:
            zoomingView.transform = zoomingView.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale)
            scrollView.snp.removeConstraints()
            scrollView.snp.makeConstraints { make in
                make.size.edges.equalTo(view)
            }
            view.isOpaque = false
            backgroundAlpha = backgroundAlpha / gestureRecognizer.scale
            if backgroundAlpha > 1.0 {
                backgroundAlpha = 1.0
            } else if backgroundAlpha < 0.5 {
                backgroundAlpha = 0.5
            }
            view.backgroundColor = UIColor(white: 0.4, alpha: backgroundAlpha)
        case .ended:
            scrollView.snp.removeConstraints()
            scrollView.snp.makeConstraints { make in
                make.top.equalTo(label.snp.bottom)
                make.left.right.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalTo(scrollView.snp.width)
            }
            UIView.animate(withDuration: 0.35, animations: {
                self.view.backgroundColor = .white
                zoomingView.transform = CGAffineTransform.identity
            })
        default:
            break
        }
        gestureRecognizer.scale = 1.0
    }
}
extension ItemViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isPagingEnabled {
            // 本当はdelegateごと分けたほうが良さそう
            pageView.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        }
    }
}
