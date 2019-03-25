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
    private var scrollView: UIScrollView!
    private var selectedImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        title = "画像投稿"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UILabel().apply { this in
            this.text = "キャンセル"
            this.textColor = .black
            this.rx.tapEvent
                .subscribe(onNext: { _ in
                    self.dismiss(animated: true)
                })
                .disposed(by: disposeBag)
        })
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "次へ", style: .plain, target: self, action: #selector(cropImage))
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

        scrollView = UIScrollView().apply { this in
            view.addSubview(this)
            this.backgroundColor = .clear
            this.showsHorizontalScrollIndicator = false
            this.showsVerticalScrollIndicator = false
            this.delegate = self
            this.minimumZoomScale = 1.0
            this.maximumZoomScale = 8.0
            this.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.left.right.equalTo(view)
                make.width.equalTo(view)
                make.height.equalTo(this.snp.width)
            }
        }

        selectedImageView = UIImageView().apply { this in
            scrollView.addSubview(this)
            this.backgroundColor = .orange
            this.contentMode = .scaleAspectFit
            this.translatesAutoresizingMaskIntoConstraints = true
            this.rx.doubleTapEvent
                .subscribe(onNext: { _ in
                    self.setDefaultScale(image: this.image, animated: true)
                })
                .disposed(by: disposeBag)
        }

        selectedImage.asDriver()
            .drive(onNext: { image in
                self.selectedImageView.image = image
                let wrate = self.scrollView.frame.width / image.size.width
                let hrate = self.scrollView.frame.height / image.size.height
                let rate = max(wrate, hrate)
                self.selectedImageView.frame.size = CGSize(width: image.size.width * rate, height: image.size.height * rate)
                self.scrollView.contentSize = self.selectedImageView.frame.size
                self.updateScrollInset()
                self.setDefaultScale(image: image, animated: false)
            })
            .disposed(by: disposeBag)

        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout()).apply { this in
            view.addSubview(this)
            this.register(ImagePickerCell.self, forCellWithReuseIdentifier: ImagePickerCell.identifier)
            this.dataSource = self
            this.delegate = self
            this.backgroundColor = .white
            this.rx.itemSelected
                .subscribe(onNext: { indexPath in
                    let photoAsset = self.photoAssets[indexPath.row]
                    self.imageManager.requestImage(for: photoAsset, targetSize: CGSize(width: 3000, height: 3000), contentMode: .aspectFill, options: nil, resultHandler: { (image, _) in
                        guard let image = image else { return }
                        self.selectedImage.accept(image)
                    })
                })
                .disposed(by: disposeBag)
            this.snp.makeConstraints { make in
                make.top.equalTo(scrollView.snp.bottom)
                make.left.right.bottom.width.equalTo(view)
                make.height.lessThanOrEqualTo(view)
            }
        }
    }
}

extension ImagePickerController {
    private func loadPhotoAssets() {
        let options = PHFetchOptions().apply { this in
            this.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        }
        let assets: PHFetchResult = PHAsset.fetchAssets(with: .image, options: options)
        assets.enumerateObjects(using: { (asset, _, _) in
            self.photoAssets.append(asset as PHAsset)
        })
        // デフォルトで選択されている画像は最新の画像にする
        let photoAsset = photoAssets[0]
        imageManager.requestImage(for: photoAsset, targetSize: CGSize(width: 3000, height: 3000), contentMode: .aspectFill, options: nil, resultHandler: { (image, _) in
            guard let image = image else { return }
            self.selectedImage.accept(image)
        })
    }

    @objc private func cropImage() {
        UIGraphicsBeginImageContextWithOptions(scrollView.frame.size, false, 0.0)
        scrollView.drawHierarchy(in: CGRect(origin: CGPoint(x: 0, y: 0), size: scrollView.frame.size), afterScreenUpdates: true)
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        let vc = ImageCropController(image: croppedImage)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ImagePickerController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return selectedImageView
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateScrollInset()
    }

    private func setDefaultScale(image: UIImage?, animated: Bool) {
        guard let image = image else { return }
        let width = image.size.width
        let height = image.size.height
        let scale = max(width / height, height / width)
        scrollView.setZoomScale(scale, animated: animated)

        var center = CGPoint()
        center.x = (scrollView.contentSize.width / 2.0) - (scrollView.frame.width / 2.0)
        center.y = (scrollView.contentSize.height / 2.0) - (scrollView.frame.height / 2.0)
        scrollView.setContentOffset(center, animated: animated)
    }

    private func updateScrollInset() {
        scrollView.contentInset = UIEdgeInsets(
            top: max((scrollView.frame.height - selectedImageView.frame.height) / 2, 0),
            left: max((scrollView.frame.width - selectedImageView.frame.width) / 2, 0),
            bottom: 0,
            right: 0
        )
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
        imageManager.requestImage(for: photoAsset, targetSize: cellSize, contentMode: .aspectFill, options: nil, resultHandler: { (image, _) in
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
