import Foundation
import UIKit
import SnapKit

class SplashViewController: UIViewController {
    var logoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        logoImageView = UIImageView(image: R.image.navigationLogo_116x34()).apply { this in
            view.addSubview(this)
            this.snp.makeConstraints{ make in
                make.center.equalToSuperview()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3, delay: 1.0, options: .curveEaseOut, animations: { () in
            self.logoImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        })
        UIView.animate(withDuration: 0.2, delay: 1.3, options: .curveEaseOut, animations: { () in
            self.logoImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.logoImageView.alpha = 0
        }, completion: { _ in
            AppDelegate.shared.rootViewController.switchToMainScreen()
        })
    }
}
