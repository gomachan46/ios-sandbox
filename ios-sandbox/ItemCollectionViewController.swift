import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ItemCollectionViewController: UIViewController {
    private let minimumSpacing: CGFloat = 1
    private let columnCount = 3
    private var items: [Item] = []
    private let disposeBag = DisposeBag()
    private var collectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.titleView = UIImageView(image: R.image.navigationLogo_116x34()!)
        items = (0..<100).map { _ in Item(username: "John", url: "https://picsum.photos/300?image=\(Int.random(in: 1...100))") }

        let scrollView = UIScrollView().apply { this in
            view.addSubview(this)
            this.snp.makeConstraints{ make in
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.left.right.bottom.equalTo(view)
            }
            this.refreshControl = refreshControl
        }
        refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
        let stackView = UIStackView().apply { this in
            scrollView.addSubview(this)
            this.axis = .vertical
            this.alignment = .fill
            this.distribution = .fill

            this.snp.makeConstraints { make in
                make.edges.equalTo(scrollView)
                make.width.equalTo(scrollView)
            }
        }

        let storiesScrollView = UIScrollView().apply { this in
            stackView.addArrangedSubview(this)
            this.snp.makeConstraints { make in
                make.height.equalTo(100)
            }
            this.showsVerticalScrollIndicator = false
            this.showsHorizontalScrollIndicator = false
        }
        let storiesStackView = UIStackView().apply { this in
            storiesScrollView.addSubview(this)
            this.axis = .horizontal
            this.alignment = .fill
            this.distribution = .fill
            this.spacing = 10

            this.snp.makeConstraints { make in
                make.edges.equalTo(storiesScrollView)
                make.height.equalTo(storiesScrollView)
            }
        }
        (1...10).forEach { _ in
            let storyView = UIView().apply { this in
                storiesStackView.addArrangedSubview(this)
            }
            let imageView = StoryImageView().apply { this in
                storyView.addSubview(this)
                this.kf.setImage(with: URL(string: "https://picsum.photos/100?image=\(Int.random(in: 1...100))"))
                this.snp.makeConstraints { make in
                    make.top.left.equalTo(storyView).inset(10)
                    make.right.equalTo(storyView).inset(10)
                    make.size.equalTo(60)
                }
            }
            UILabel().apply { this in
                storyView.addSubview(this)
                this.text = "ドリンクの作り方"
                this.font = .systemFont(ofSize: 12)
                this.textAlignment = .center
                this.snp.makeConstraints { make in
                    make.top.equalTo(imageView.snp.bottom)
                    make.centerX.equalTo(imageView)
                    make.width.equalTo(storyView)
                    make.height.equalTo(30)
                }
            }
        }

        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout()).apply { this in
            stackView.addArrangedSubview(this)
            this.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.identifier)
            this.dataSource = self
            this.delegate = self
            this.backgroundColor = .white
            this.rx.itemSelected
                .subscribe(onNext: { indexPath in
                    let item = self.items[indexPath.row]
                    self.navigationController?.pushViewController(ItemViewController(item: item), animated: true)
                })
                .disposed(by: disposeBag)
            this.snp.makeConstraints { make in
                make.height.equalTo(scrollView)
            }
        }
    }
}

extension ItemCollectionViewController {
    @objc private func refresh(sender: UIRefreshControl) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        DispatchQueue.global(qos: .userInteractive).async {
            Thread.sleep(forTimeInterval: 2.0)
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.refreshControl.endRefreshing()
            }
        }
    }
}

extension ItemCollectionViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as! ItemCollectionViewCell
        cell.update(item: items[indexPath.row])
        return cell
    }
}

extension ItemCollectionViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = (view.frame.width / CGFloat(columnCount)) - minimumSpacing
        return CGSize(width: length, height: length)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumSpacing
    }
}
