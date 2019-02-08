import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class SampleItemViewController: UIViewController {
    private let item = BehaviorRelay<SampleItem>(value: SampleItem())
    private let disposeBag = DisposeBag()

    init(item i: SampleItem) {
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
        UIImageView().apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            this.contentMode = .scaleAspectFit
            item.asDriver().drive(onNext: { item in
                this.kf.setImage(with: URL(string: item.url))
            })
            .disposed(by: disposeBag)
        }
    }
}
