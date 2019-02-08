import Foundation
import UIKit
import SnapKit
import Lottie

class SplashViewController: UIViewController {
    var logoImageView: UIImageView!
    var animationView: LOTAnimationView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        logoImageView = UIImageView(image: R.image.navigationLogo_116x34()).apply { this in
            view.addSubview(this)
            this.snp.makeConstraints{ make in
                make.center.equalToSuperview()
            }
        }
        animationView = LOTAnimationView(filePath: R.file.sampleDataJson.path()!).apply { this in
            view.addSubview(this)
            this.snp.makeConstraints { make in
                make.center.equalTo(logoImageView)
                make.top.equalToSuperview()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.2, delay: 0.4, options: .curveEaseOut, animations: { () in
            self.logoImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.logoImageView.alpha = 0
        })
        animationView.play(fromProgress: 0.4, toProgress: 0.7, withCompletion: { _ in
            AppDelegate.shared.rootViewController.switchToMainScreen()
        })
    }
}
