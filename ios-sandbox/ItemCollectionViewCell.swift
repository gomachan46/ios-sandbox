import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class ItemCollectionViewCell: UICollectionViewCell {
    static let identifier = "ItemCollectionViewCell"
    private let disposeBag = DisposeBag()
    private let item = BehaviorRelay<Item>(value: Item())

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ItemCollectionViewCell {
    func update(item i: Item) {
        item.accept(i)
    }

    private func makeViews() {
        contentView.backgroundColor = .lightGray
        UIImageView().apply { this in
            contentView.addSubview(this)
            this.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            item.asDriver().drive(onNext: { item in
                this.kf.setImage(with: URL(string: item.url))
            })
            .disposed(by: disposeBag)
        }
    }
}
