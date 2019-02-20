import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class ImagePickerController: UIViewController {
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UILabel().apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.size.edges.equalTo(view)
            }
            this.text = "hello"
            this.textColor = .black
            this.backgroundColor = .white
        }
        title = "hi"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UILabel().apply { this in
            this.text = "キャンセル"
            this.textColor = .black
            this.rx.tapEvent
                .subscribe(onNext: { _ in
                    self.dismiss(animated: true)
                })
                .disposed(by: disposeBag)
        })
    }
}
