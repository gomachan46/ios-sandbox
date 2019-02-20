import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ImagePickerCell: UICollectionViewCell {
    static let identifier = "ImagePickerCell"
    private let disposeBag = DisposeBag()
    private let image = BehaviorRelay<UIImage>(value: UIImage())

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ImagePickerCell {
    func update(image i: UIImage) {
        image.accept(i)
    }

    private func makeViews() {
        contentView.backgroundColor = .white
        UIImageView().apply { this in
            contentView.addSubview(this)
            this.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            image.asDriver()
                .drive(onNext: { image in
                    this.image = image
                })
                .disposed(by: disposeBag)
        }
    }
}
