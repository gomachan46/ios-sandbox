import Foundation
import RxSwift

class HogeStoryViewModel {
    private let navigator: StoryNavigator
    let story: Observable<Story>

    init(navigator: StoryNavigator, story: Story) {
        self.navigator = navigator
        self.story = Observable.from(optional: story)
    }
}

extension HogeStoryViewModel: ViewModelType {
    struct Input {
        let tapCancel: Observable<Void>
    }

    struct Output {
        let canceled: Observable<Void>
    }

    func transform(input: Input) -> Output {
        let canceled = input.tapCancel.do(onNext: navigator.dismiss)
        return Output(canceled: canceled)
    }
}
