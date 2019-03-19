import Foundation
import RxSwift
import RxCocoa

struct AllBookmarksViewModel {
    private let navigator: AllBookmarksNavigator

    init(navigator: AllBookmarksNavigator) {
        self.navigator = navigator
    }
}

extension AllBookmarksViewModel: ViewModelType {
    struct Input {
        let refreshTrigger: Observable<Void>
        let selection: Observable<IndexPath>
    }

    struct Output {
        let sectionOfBookmark: Observable<[SectionOfBookmark]>
        let selectedBookmark: Observable<Bookmark>
    }

    func transform(input: Input) -> Output {
        let bookmarks = input
            .refreshTrigger
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .userInteractive))
            .flatMapLatest { _ -> Observable<[Bookmark]> in
                // API叩いてデータ取ってきて[Bookmark]を取得する、みたいなところのイメージ
                // ちゃんとするなら外出ししていくはず
                return Observable.create { observer -> Disposable in
                    Thread.sleep(forTimeInterval: 1)
                    observer.onNext(
                        (0..<30).map { _ in
                            [
                                Bookmark(keyword: "レースブラウス", url: URL(string: "https://picsum.photos/300/600?image=\(Int.random(in: 1...100))"), type: .topic),
                                Bookmark(keyword: "who's who Chico(フーズフーチコ)のオサイフドッキングポシェット", url: URL(string: "https://picsum.photos/300/600?image=\(Int.random(in: 1...100))"), type: .topic),
                                Bookmark(keyword: "レースブラウス", url: URL(string: "https://picsum.photos/300/300?image=\(Int.random(in: 1...100))"), type: .image)
                            ].shuffled().first!
                        }
                    )
                    return Disposables.create()
                }
            }
            .share(replay: 1)
        let sectionOfBookmark = bookmarks.map { [SectionOfBookmark(items: $0)] }
        let selectedBookmark = input
            .selection
            .withLatestFrom(bookmarks) { (indexPath, bookmarks) -> Bookmark in bookmarks[indexPath.row] }
            .do(onNext: navigator.toBookmark)

        return Output(sectionOfBookmark: sectionOfBookmark, selectedBookmark: selectedBookmark)
    }
}
