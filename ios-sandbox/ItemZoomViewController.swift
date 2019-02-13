import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class ItemZoomViewController: UIViewController {
    private let item = BehaviorRelay<Item>(value: Item())
    private var imageView: UIImageView!
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
        let pageScrollView = UIScrollView().apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.size.equalTo(view)
            }
            this.showsHorizontalScrollIndicator = false
            this.showsVerticalScrollIndicator = false
            this.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(self.pinchGesture(_:))))
        }
        imageView = UIImageView().apply { this in
            pageScrollView.addSubview(this)
            this.snp.makeConstraints { make in
                make.size.equalTo(view)
            }
            this.contentMode = .scaleAspectFit
            item.asDriver()
                .drive(onNext: { item in
                    this.kf.setImage(with: URL(string: item.url))
                })
                .disposed(by: disposeBag)
        }
    }
}

extension ItemZoomViewController {
    @objc func pinchGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard let zoomingView = gestureRecognizer.view else { return }
        switch gestureRecognizer.state {
        case .began:
            zoomingView.transform = zoomingView.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale)
            presentingViewController?.view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        case .changed:
            zoomingView.transform = zoomingView.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale)
        case .ended:
            UIView.animate(withDuration: 0.35, animations: {
                zoomingView.transform = CGAffineTransform.identity
            })
        default:
            break
        }
        gestureRecognizer.scale = 1.0
    }
}
