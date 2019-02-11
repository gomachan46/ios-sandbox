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
            this.minimumZoomScale = 1.0
            this.maximumZoomScale = 20.0
            this.delegate = self
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

extension ItemZoomViewController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollView.setZoomScale(1.0, animated: true)
    }
}
