import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class ItemViewController: UIViewController {
    private var scrollView: UIScrollView!
    private var pageView: UIPageControl!
    private var stackView: UIStackView!
    private var label: UILabel!
    private let item = BehaviorRelay<Item>(value: Item())
    private let disposeBag = DisposeBag()
    private var backgroundAlpha: CGFloat = 1.0
    private var currentTransform: CGAffineTransform!
    private var viewCenter: CGPoint!
    private var pinchCenter: CGPoint!
    private var isZooming: Bool = false
    private var layerView: UIView!

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
            this.snp.makeConstraints { make in
                make.top.equalTo(scrollView.snp.bottom)
                make.left.right.equalToSuperview()
                make.height.equalTo(50)
            }
        }
        stackView = UIStackView().apply { this in
            scrollView.addSubview(this)
            this.translatesAutoresizingMaskIntoConstraints = false
            this.isUserInteractionEnabled = true
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
                item.asDriver().drive(onNext: { item in
                        this.kf.setImage(with: URL(string: "https://picsum.photos/300?image=\(Int.random(in: 1...100))"))
                    })
                    .disposed(by: disposeBag)
                this.clipsToBounds = false
                this.translatesAutoresizingMaskIntoConstraints = false
                this.isUserInteractionEnabled = true
                let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGesture(_:)))
                pinchGesture.delegate = self
                this.addGestureRecognizer(pinchGesture)
                let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGesture(_:)))
                panGesture.minimumNumberOfTouches = 1
                panGesture.maximumNumberOfTouches = 2
                panGesture.delegate = self
                this.addGestureRecognizer(panGesture)
            }
        }
    }
}

extension ItemViewController {
    @objc func panGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard isZooming else { return }
        guard let zoomingView = gestureRecognizer.view else { return }

        let transform = zoomingView.transform
        zoomingView.transform = CGAffineTransform.identity

        let point = gestureRecognizer.translation(in: zoomingView)
        let movedPoint = CGPoint(x: zoomingView.center.x + point.x, y: zoomingView.center.y + point.y)
        zoomingView.center = movedPoint
        zoomingView.transform = transform
    }

    @objc func pinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard let zoomingView = gestureRecognizer.view else { return }

        switch gestureRecognizer.state {
        case .began:
            scrollView.snp.removeConstraints()
            scrollView.snp.makeConstraints { make in
                make.size.edges.equalTo(view)
            }
            stackView.translatesAutoresizingMaskIntoConstraints = true
            zoomingView.translatesAutoresizingMaskIntoConstraints = true
            currentTransform = zoomingView.transform
            viewCenter = zoomingView.center
            let touchPoint1 = gestureRecognizer.location(ofTouch: 0, in: view)
            let touchPoint2 = gestureRecognizer.location(ofTouch: 1, in: view)
            pinchCenter = CGPoint(x: (touchPoint1.x + touchPoint2.x) / 2, y: (touchPoint1.y + touchPoint2.y) / 2)
            isZooming = true
        case .changed:
            let scale = gestureRecognizer.scale
            let newCenter = CGPoint(x: viewCenter.x - ((pinchCenter.x - viewCenter.x) * scale - (pinchCenter.x - viewCenter.x)), y: viewCenter.y - ((pinchCenter.y - viewCenter.y) * scale - (pinchCenter.y - viewCenter.y)))

            zoomingView.center = newCenter
            zoomingView.transform = currentTransform.concatenating(CGAffineTransform(scaleX: scale, y: scale))

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
                make.left.right.equalTo(view)
                make.width.equalTo(view)
                make.height.equalTo(scrollView.snp.width)
            }
            zoomingView.translatesAutoresizingMaskIntoConstraints = false
            stackView.translatesAutoresizingMaskIntoConstraints = false
            UIView.animate(withDuration: 0.35, animations: {
                self.view.backgroundColor = .white
                zoomingView.transform = CGAffineTransform.identity
            })
            isZooming = false
        default:
            break
        }
    }
}
extension ItemViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageView.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
}

extension ItemViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
