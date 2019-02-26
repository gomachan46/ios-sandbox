import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class FeedViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        StoriesView().apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.left.right.equalTo(view)
            }
        }
    }
}
