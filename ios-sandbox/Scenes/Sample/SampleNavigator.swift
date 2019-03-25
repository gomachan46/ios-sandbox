import UIKit
import FloatingPanel

protocol SampleNavigatorType {
    static func root() -> UIViewController
}

struct SampleNavigator: SampleNavigatorType {

    static func root() -> UIViewController {
        let navigator = self.init()
        let viewModel = SampleViewModel(navigator: navigator)
        let contentViewController = SampleViewController(viewModel: viewModel)
        let viewController = SampleFloatingPanelController(contentViewController: contentViewController)

        return viewController
    }
}
