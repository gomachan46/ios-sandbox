import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class ItemCollectionViewCell: UICollectionViewCell {
    static let identifier = "ItemCollectionViewCell"
    private let disposeBag = DisposeBag()
    private let item = BehaviorRelay<Item>(value: Item())
    private var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeViews()
        setupViewModel()
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
        contentView.backgroundColor = .white
        imageView = UIImageView().apply { this in
            contentView.addSubview(this)
            this.snp.makeConstraints { make in
                make.edges.equalTo(contentView)
            }
        }
    }

    private func setupViewModel() {
        item.asDriver().drive(onNext: { item in
                self.imageView.kf.setImage(with: URL(string: item.url))
            })
            .disposed(by: disposeBag)
    }
}
