import Foundation
import RxSwift
import RxCocoa

struct SampleViewModel {
    private let navigator: SampleNavigator

    init(navigator: SampleNavigator) {
        self.navigator = navigator
    }
}

extension SampleViewModel: ViewModelType {
    struct Input {
    }

    struct Output {
    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
