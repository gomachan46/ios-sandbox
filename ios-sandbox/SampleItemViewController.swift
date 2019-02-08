import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SampleItemViewController: UIViewController {
    private var item: SampleItem
    private let disposeBag = DisposeBag()

    init(item i: SampleItem) {
        item = i
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        UILabel().apply { this in
            view.addSubview(this)
            this.text = item.url
            this.textColor = .black
            this.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
    }
}
