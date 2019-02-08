import Foundation
import UIKit

class RootViewController: UIViewController {
    private var current: UIViewController

    init () {
        current = SplashViewController()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParent: self)
    }
}

extension RootViewController {
    func switchToMainScreen() {
        let new = TabBarController()
        addChild(new)
        new.view.frame = view.bounds
        view.addSubview(new.view)
        new.didMove(toParent: self)

        current.willMove(toParent: nil)
        current.view.removeFromSuperview()
        current.removeFromParent()

        current = new
    }
}
