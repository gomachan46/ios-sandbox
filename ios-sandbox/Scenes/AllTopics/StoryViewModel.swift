import Foundation
import RxSwift

class StoryViewModel {
    private let navigator: AllTopicsNavigator
    let story: Observable<Story>

    init(navigator: AllTopicsNavigator, story: Story) {
        self.navigator = navigator
        self.story = Observable.from(optional: story)
    }
}

extension StoryViewModel: ViewModelType {
    struct Input {
        let selection: Observable<Void>
    }

    struct Output {
        let title: Observable<String>
        let url: Observable<URL?>
        let selectedStory: Observable<Story>
    }

    func transform(input: Input) -> Output {
        let selectedStory = input
            .selection
            .withLatestFrom(story)
            .do(onNext: { story in print(story) })


        let title = story.map { $0.title }
        let url = story.map { $0.url }
        return Output(title: title, url: url, selectedStory: selectedStory)
    }
}
