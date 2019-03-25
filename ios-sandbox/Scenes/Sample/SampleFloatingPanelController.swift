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
        fpc.delegate = self
        fpc.set(contentViewController: contentViewController)
        fpc.addPanel(toParent: self)
    }
}

extension SampleFloatingPanelController: FloatingPanelControllerDelegate {
    public func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return SampleFloatingPanelControllerLayout()
    }

    public func floatingPanel(_ vc: FloatingPanelController, behaviorFor newCollection: UITraitCollection) -> FloatingPanelBehavior? {
        return SelectUploadImageFloatingPanelBehavior()
    }
}

class SampleFloatingPanelControllerLayout: FloatingPanelLayout {
    var initialPosition: FloatingPanelPosition {
        return .tip
    }
    var supportedPositions: Set<FloatingPanelPosition> {
        return [.full, .tip]
    }

    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return 56.0
        case .tip: return 200.0
        default: return nil
        }
    }
}

class SampleFloatingPanelControllerBehavior: FloatingPanelBehavior {
}
