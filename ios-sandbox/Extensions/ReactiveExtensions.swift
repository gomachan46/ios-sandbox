import RxSwift
import UIKit

extension Reactive where Base: UIView {
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
