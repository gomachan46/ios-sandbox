import UIKit
import SnapKit

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setup()
    }
}

extension NavigationController {
    private func setup() {
        navigationBar.backgroundColor = .black
    }
}
