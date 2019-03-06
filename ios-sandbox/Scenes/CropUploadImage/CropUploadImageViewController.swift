import UIKit
import SnapKit

class CropUploadImageViewController: UIViewController {
    private let viewModel: CropUploadImageViewModel

    init(viewModel: CropUploadImageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeViews()
        bindViewModel()
    }
}

extension CropUploadImageViewController {
    private func makeViews() {
        view.backgroundColor = .white
        UILabel().apply { this in
            view.addSubview(this)
            this.text = "hello"
            this.textColor = .black
            this.snp.makeConstraints { make in
                make.center.equalTo(view)
            }
        }
    }

    private func bindViewModel() {
    }
}