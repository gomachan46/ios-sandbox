import Foundation
import RxSwift
import RxCocoa

struct SelectUploadImageViewModel {
    private let navigator: SelectUploadImageNavigator

    init(navigator: SelectUploadImageNavigator) {
        self.navigator = navigator
    }
}

extension SelectUploadImageViewModel: ViewModelType {
    struct Input {
    }

    struct Output {
    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
