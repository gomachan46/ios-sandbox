import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Photos

class ImagePickerController: UIViewController {
    private let disposeBag = DisposeBag()
    private var photoAssets = [PHAsset]()
    private var collectionView: UICollectionView!
    private let minimumSpacing: CGFloat = 1
    private let columnCount = 4
    private var cellSize: CGSize!
    private let imageManager = PHImageManager.default()
    private let selectedImage = BehaviorRelay<UIImage>(value: UIImage())

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        title = "画像投稿"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UILabel().apply { this in
            this.text = "キャンセル"
            this.textColor = .black
            this.rx.tapEvent
                .subscribe(onNext: { _ in
                    self.dismiss(animated: true)
                })
                .disposed(by: disposeBag)
        })
        let cellLength = (view.frame.width / CGFloat(columnCount)) - minimumSpacing
        cellSize = CGSize(width: cellLength, height: cellLength)
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            loadPhotoAssets()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { _ in
                self.loadPhotoAssets()
                self.collectionView.reloadData()
            }
        default:
            // TODO: 設定画面から許可してねっていうのを出す
            break
        }

        let selectedImageView = UIImageView().apply { this in
            view.addSubview(this)
            this.backgroundColor = .lightGray
            selectedImage.asDriver().drive(onNext: { image in
                this.image = image
            })
            .disposed(by: disposeBag)
            this.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.left.right.equalTo(view)
                make.width.equalTo(view)
                make.height.equalTo(this.snp.width)
            }
        }

        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout()).apply { this in
            view.addSubview(this)
            this.register(ImagePickerCell.self, forCellWithReuseIdentifier: ImagePickerCell.identifier)
            this.dataSource = self
            this.delegate = self
            this.backgroundColor = .white
            this.rx.itemSelected
                .subscribe(onNext: { indexPath in
                    let photoAsset = self.photoAssets[indexPath.row]
                    self.imageManager.requestImage(for: photoAsset, targetSize: CGSize(width: self.view.frame.width, height: self.view.frame.width), contentMode: .aspectFill, options: nil, resultHandler: { (image, info) in
                        guard let image = image else { return }
                        selectedImageView.image = image
                    })
                })
                .disposed(by: disposeBag)
            this.snp.makeConstraints { make in
                make.top.equalTo(selectedImageView.snp.bottom)
                make.left.right.bottom.width.equalTo(view)
                make.height.lessThanOrEqualTo(view)
            }
        }
    }
}

extension ImagePickerController {
    private func loadPhotoAssets() {
        let options = PHFetchOptions().apply { this in
            this.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending:  false)]
        }
        let assets: PHFetchResult = PHAsset.fetchAssets(with: .image, options: options)
        assets.enumerateObjects(using: { (asset, index, stop) in
            self.photoAssets.append(asset as PHAsset)
        })
        // デフォルトで選択されている画像は最新の画像にする
        let photoAsset = photoAssets[0]
        imageManager.requestImage(for: photoAsset, targetSize: CGSize(width: self.view.frame.width, height: self.view.frame.width), contentMode: .aspectFill, options: nil, resultHandler: { (image, info) in
            guard let image = image else { return }
            self.selectedImage.accept(image)
        })
    }
}

extension ImagePickerController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAssets.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePickerCell.identifier, for: indexPath) as! ImagePickerCell
        let photoAsset = photoAssets[indexPath.row]
        imageManager.requestImage(for: photoAsset, targetSize: cellSize, contentMode: .aspectFill, options: nil, resultHandler: { (image, info) in
            guard let image = image else { return }
            cell.update(image: image)
        })
        return cell
    }
}

extension ImagePickerController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumSpacing
    }
}
