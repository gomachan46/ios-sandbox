import Foundation
import RxSwift
import UIKit

protocol ApplyProtocol {}
extension ApplyProtocol {
    @discardableResult func apply(_ closure: (_ this: Self) -> Void) -> Self {
        closure(self)
        return self
    }
}
extension NSObject: ApplyProtocol {}

extension Reactive where Base: UIView
{
    func gesture<T: UIGestureRecognizer>() -> Observable<T> {
        return Observable.create({ observer -> Disposable in
            let gesture = T()
            self.base.addGestureRecognizer(gesture)
            self.base.isUserInteractionEnabled = true
            return gesture.rx.event
                .subscribe(onNext: { sender in
                observer.onNext(sender)
            })
        })
    }
    var tapEvent: Observable<UITapGestureRecognizer> { return gesture() }
    var doubleTapEvent: Observable<[UITapGestureRecognizer]> {
        return tapEvent
            .buffer(timeSpan: 1, count: 2, scheduler: MainScheduler.instance)
            .filter { $0.count == 2 }
    }
    var longPressEvent: Observable<UILongPressGestureRecognizer> { return gesture() }
}
