import Foundation
import RxSwift

class StoriesViewModel {
}

extension StoriesViewModel: ViewModelType {
    struct Input {
    }

    struct Output {
        let stories: Observable<[Story]>
    }

    func transform(input: Input) -> Output {
        let stories: Observable<[Story]> = Observable.create { observer -> Disposable in
            observer.onNext(
                (0..<10).map { _ in
                    Story(
                        title: "ドリンクの作り方",
                        url: URL(string: "https://picsum.photos/300?image=\(Int.random(in: 1...100))")
                    )
                }
            )
            return Disposables.create()
        }

        return Output(stories: stories)
    }
}
