import Foundation
import RxSwift
import RxDataSources
import Differentiator

struct SectionOfTopic {
    var items: [TopicItemViewModel]
}

extension SectionOfTopic: SectionModelType {
    typealias Item = TopicItemViewModel

    init(original: SectionOfTopic, items: [SectionOfTopic.Item]) {
        self = original
        self.items = items
    }
}

class AllTopicsViewModel {
    private let navigator: AllTopicsNavigator
    private var isFetching = Observable.from(optional: false)

    init(navigator: AllTopicsNavigator) {
        self.navigator = navigator
    }
}

extension AllTopicsViewModel: ViewModelType {
    struct Input {
        let selection: Observable<IndexPath>
        let refreshTrigger: Observable<Void>
    }

    struct Output {
        let topics: Observable<[SectionOfTopic]>
        let selectedTopic: Observable<Topic>
        let isFetching: Observable<Bool>
    }

    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let topics = input
            .refreshTrigger
            .flatMapLatest { _ in
                return Observable
                    .from(optional: (0..<30).map { _ -> Topic in
                        (0..<10000).forEach { n in print(n) } // TODO: 非同期にしたい！
                        return Topic(username: "John", url: "https://picsum.photos/300?image=\(Int.random(in: 1...100))")
                    })
                    .trackActivity(activityIndicator)
            }
            .share(replay: 1)

        let selectedTopic = input
            .selection
            .withLatestFrom(topics) {
                (indexPath, topics) -> Topic in topics[indexPath.row]
            }
            .do(onNext: navigator.toTopic)
        let topicItemViewModels = topics.map { [SectionOfTopic(items: $0.map { TopicItemViewModel(with: $0) })] }

        return Output(topics: topicItemViewModels, selectedTopic: selectedTopic, isFetching: activityIndicator.asObservable())
    }
}
