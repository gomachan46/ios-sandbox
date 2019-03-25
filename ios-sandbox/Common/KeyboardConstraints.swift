import UIKit
import RxSwift
import RxCocoa
import SnapKit

extension UIViewController {
    /// [!] 引数bottomViewのbottom制約はequalToSafeAreaLayoutGuideに対して指定しておくこと！
    /// キーボードの表示･非表示に合わせてbottomViewのbottom制約を更新する
    func connectKeyboardEvents(to bottomView: UIView, bottomInset: CGFloat = 0, disposeBag: DisposeBag) {
        let tabBarHeight = tabBarController?.tabBar.bounds.height ?? 0

        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: { [unowned self] notification in
                guard let userInfo = notification.userInfo,
                    let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

                bottomView.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(bottomInset)
                }
                UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(UIResponder.keyboardWillChangeFrameNotification)
            .subscribe(onNext: { [unowned self] notification in
                guard let userInfo = notification.userInfo,
                    let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height,
                    let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

                bottomView.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardHeight - tabBarHeight + bottomInset)
                }
                UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
            })
            .disposed(by: disposeBag)
    }
}
