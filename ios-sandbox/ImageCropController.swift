import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Photos

class ImageCropController: UIViewController {
    private var image: UIImage!

    init(image i: UIImage) {
        image = i
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        UIImageView(image: image).apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.left.right.equalTo(view)
            }
        }
    }
}
