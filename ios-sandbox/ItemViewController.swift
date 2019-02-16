import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class ItemViewController: UIViewController {
    private var label: UILabel!
    private let item = BehaviorRelay<Item>(value: Item())
    private var pageView: UIPageControl!
    private let disposeBag = DisposeBag()
    private var scrollView: UIScrollView!
    private var imageOriginalCenter: CGPoint!
    private var overlay: UIView!

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
        let stackView = UIStackView().apply { this in
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
                this.layer.masksToBounds = true
                this.translatesAutoresizingMaskIntoConstraints = false
                this.isUserInteractionEnabled = true
                let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handleZoom))
                let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
                panGesture.minimumNumberOfTouches = 2
                panGesture.maximumNumberOfTouches = 2
                pinchGesture.delegate = self
                panGesture.delegate = self
                this.addGestureRecognizer(pinchGesture)
                this.addGestureRecognizer(panGesture)
            }
        }
        overlay = UIView().apply { this in
            view.addSubview(this)
            this.alpha = 0
            this.backgroundColor = .black
            this.snp.makeConstraints { make in
                make.size.edges.equalTo(view)
            }
        }
        view.bringSubviewToFront(scrollView)
    }
}

extension ItemViewController: UIGestureRecognizerDelegate {

    // That method make it works
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    @objc func handleZoom(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began, .changed:

            // Only zoom in, not out
            if gesture.scale >= 1 {

                // Get the scale from the gesture passed in the function
                let scale = gesture.scale

                gesture.view!.transform = CGAffineTransform(scaleX: scale, y: scale)
            }

            // Show the overlay
            UIView.animate(withDuration: 0.2) {
                self.overlay.alpha = 0.8
            }
        default:
            // If the gesture has cancelled/terminated/failed or everything else that's not performing
            // Smoothly restore the transform to the "original"
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                gesture.view!.transform = .identity
            }) { _ in
                // Hide the overlay
                UIView.animate(withDuration: 0.2) {
                    self.overlay.alpha = 0
                }
            }
        }
    }

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            imageOriginalCenter = gesture.view!.center
        }
        switch gesture.state {
        case .began, .changed:
            // Get the touch position
            let translation = gesture.translation(in: gesture.view!)

            // Edit the center of the target by adding the gesture position
            gesture.view!.center = CGPoint(x: gesture.view!.center.x + translation.x, y: gesture.view!.center.y + translation.y)
            gesture.setTranslation(.zero, in: gesture.view!)

            // Show the overlay
            UIView.animate(withDuration: 0.2) {
                self.overlay.alpha = 0.8
            }
        default:
            // If the gesture has cancelled/terminated/failed or everything else that's not performing
            // Smoothly restore the transform to the "original"
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                gesture.view!.center = self.imageOriginalCenter
            }) { _ in
                // Hide the overlay
                UIView.animate(withDuration: 0.2) {
                    self.overlay.alpha = 0
                }
            }
        }
    }
}
extension ItemViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageView.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
}
