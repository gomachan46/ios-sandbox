import UIKit
import FloatingPanel

class SampleFloatingPanelController: UIViewController {
    private var fpc: FloatingPanelController!
    private let contentViewController: SampleViewController

    init(contentViewController: SampleViewController) {
        self.contentViewController = contentViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fpc = FloatingPanelController()
        fpc.set(contentViewController: contentViewController)
        fpc.addPanel(toParent: self)
    }
}
