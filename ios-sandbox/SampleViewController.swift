import Foundation
import UIKit
import Kingfisher
import SnapKit

class SampleViewController: UIViewController {
    // MARK: - UI Initialization

    // The image that we will zoom/drag
    var label: UILabel!
    var imageView = UIImageView()
    var imageOriginalCenter: CGPoint!

    // The dark overlay layer behind the image
    // that will be visible while gestures are recognized
    var overlay: UIView = {
        let v = UIView(frame: UIScreen.main.bounds);

        v.alpha = 0
        v.backgroundColor = .black

        return v
    }()

    // Let's start
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        label = UILabel().apply { this in
            view.addSubview(this)
            this.text = "John"
            this.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide)
                make.left.equalToSuperview().inset(20)
                make.right.equalToSuperview()
                make.height.equalTo(50)
            }
        }

        view.addSubview(imageView)
        view.addSubview(overlay)
        view.bringSubviewToFront(imageView)
        setupImageView()

        // Do not forget to enable user interaction on our imageView
        imageView.isUserInteractionEnabled = true

        // MARK: - UIGesturesRecognizers
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handleZoom))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))

        // Use 2 thingers to move the view
        pan.minimumNumberOfTouches = 2
        pan.maximumNumberOfTouches = 2

        // We delegate gestures so we can
        // perform both at the same time
        pan.delegate = self
        pinch.delegate = self

        // Add the gestures to our target (imageView)
        imageView.addGestureRecognizer(pinch)
        imageView.addGestureRecognizer(pan)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageOriginalCenter = imageView.center
    }

    /// Setup imageView
    private func setupImageView() {

        // Set the image
        imageView.kf.setImage(with: URL(string: "https://picsum.photos/300?image=\(Int.random(in: 1...100))"))

        // Resize the content
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true

        // That was for testing porpouse only
        // imageView.backgroundColor = .red
        // Constraints
        setupImageViewConstraints()
    }

    /// Setup ImageView constraints
    private func setupImageViewConstraints() {

        // Disable Autoresizing Masks into Constraints
        imageView.translatesAutoresizingMaskIntoConstraints = false

        // Constraints
        imageView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom)
            make.left.right.equalTo(view)
            make.width.equalTo(view)
            make.height.equalTo(imageView.snp.width)
        }

        view.layoutIfNeeded()
    }
}


// MARK: - Extension
extension SampleViewController: UIGestureRecognizerDelegate {

    // That method make it works
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    @objc func handleZoom(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began, .changed:

            // Only zoom in, not out
            if gesture.scale >= 1 {

                // Get the scale from the gesture passed in the function
                let scale = gesture.scale

                // use CGAffineTransform to transform the imageView
                gesture.view!.transform = CGAffineTransform(scaleX: scale, y: scale)
            }


            // Show the overlay
            UIView.animate(withDuration: 0.2) {
                self.overlay.alpha = 0.8
            }
            break;
        default:
            // If the gesture has cancelled/terminated/failed or everything else that's not performing
            // Smoothly restore the transform to the "original"
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                gesture.view!.transform = .identity
            }) { _ in
                // Hide the overlay
                UIView.animate(withDuration: 0.2) {
                    self.overlay.alpha = 0
                }
            }
        }
    }

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began, .changed:
            // Get the touch position
            let translation = gesture.translation(in: imageView)

            // Edit the center of the target by adding the gesture position
            gesture.view!.center = CGPoint(x: imageView.center.x + translation.x, y: imageView.center.y + translation.y)
            gesture.setTranslation(.zero, in: imageView)

            // Show the overlay
            UIView.animate(withDuration: 0.2) {
                self.overlay.alpha = 0.8
            }
            break;
        default:
            // If the gesture has cancelled/terminated/failed or everything else that's not performing
            // Smoothly restore the transform to the "original"
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                gesture.view!.center = self.imageOriginalCenter
            }) { _ in
                // Hide the overaly
                UIView.animate(withDuration: 0.2) {
                    self.overlay.alpha = 0
                }
            }
            break
        }
    }
}
