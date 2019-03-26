import UIKit
import RxSwift
import RxCocoa
import SnapKit

extension UIViewController {
    /// キーボードの表示･非表示に合わせてオートレイアウト制約を更新する
    func connectKeyboardEvents(top topView: UIView, bottom bottomView: UIView, topInset: CGFloat = 0, bottomInset: CGFloat = 0, disposeBag: DisposeBag) {
        let tabBarHeight = tabBarController?.tabBar.bounds.height ?? 0

        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: { [unowned self] notification in
                guard let userInfo = notification.userInfo,
                    let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

                topView.snp.updateConstraints { make in
                    make.top.equalTo(self.view.safeAreaLayoutGuide).inset(topInset)
                }
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

                topView.snp.updateConstraints { make in
                    make.top.equalTo(self.view.safeAreaLayoutGuide).inset(-1 * (keyboardHeight - tabBarHeight + topInset))
                }
                bottomView.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardHeight - tabBarHeight + bottomInset)
                }
                UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
            })
            .disposed(by: disposeBag)
    }
}
