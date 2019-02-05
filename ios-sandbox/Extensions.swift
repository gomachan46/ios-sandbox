import Foundation

protocol ApplyProtocol {}
extension ApplyProtocol {
    @discardableResult func apply(_ closure: (_ this: Self) -> Void) -> Self {
        closure(self)
        return self
    }
}

extension NSObject: ApplyProtocol {}
