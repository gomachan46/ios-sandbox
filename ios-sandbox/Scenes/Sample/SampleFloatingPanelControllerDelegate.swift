import UIKit
import FloatingPanel

class SampleFloatingPanelControllerDelegate {
}

extension SampleFloatingPanelControllerDelegate: FloatingPanelControllerDelegate {
    public func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return SampleFloatingPanelControllerLayout()
    }

    public func floatingPanel(_ vc: FloatingPanelController, behaviorFor newCollection: UITraitCollection) -> FloatingPanelBehavior? {
        return SelectUploadImageFloatingPanelBehavior()
    }
}

class SampleFloatingPanelControllerLayout: FloatingPanelLayout {
    var initialPosition: FloatingPanelPosition {
        return .hidden
    }
    var supportedPositions: Set<FloatingPanelPosition> {
        return [.full, .half, .tip, .hidden]
    }

    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return 56.0
        case .half: return 200.0
        case .tip: return nil
        case .hidden: return nil
        }
    }

    func backdropAlphaFor(position: FloatingPanelPosition) -> CGFloat {
        switch position {
        case .full, .half:
            return 0.5
        case .tip, .hidden:
            return 0.0
        }
    }
}

class SampleFloatingPanelControllerBehavior: FloatingPanelBehavior {
}
