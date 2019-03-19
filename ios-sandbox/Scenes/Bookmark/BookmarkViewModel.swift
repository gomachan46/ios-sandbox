import Foundation
import RxSwift
import RxCocoa

struct BookmarkViewModel {
    private let navigator: BookmarkNavigator

    init(navigator: BookmarkNavigator) {
        self.navigator = navigator
    }
}

extension BookmarkViewModel: ViewModelType {
    struct Input {
        let refreshTrigger: Observable<Void>
    }

    struct Output {
        let sectionOfBookmark: Observable<[SectionOfBookmark]>
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

        return Output(sectionOfBookmark: sectionOfBookmark)
    }
}
