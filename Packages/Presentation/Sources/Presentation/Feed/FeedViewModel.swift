import Foundation
import Domain

@Observable
public final class FeedViewModel {
    public enum State {
        case idle
        case loading
        case loaded([Character])
        case loadingMore([Character])
        case error(Error)
    }

    public private(set) var state: State = .idle
    private let fetchFeed: any FetchFeedUseCaseProtocol
    private var currentPage = 1
    private var hasNextPage = true

    public var characters: [Character] {
        switch state {
        case .loaded(let chars), .loadingMore(let chars): return chars
        default: return []
        }
    }

    public var isLoading: Bool {
        if case .loading = state { return true }
        return false
    }

    public var isLoadingMore: Bool {
        if case .loadingMore = state { return true }
        return false
    }

    public var errorMessage: String? {
        if case .error(let error) = state { return error.localizedDescription }
        return nil
    }

    public init(fetchFeed: any FetchFeedUseCaseProtocol) {
        self.fetchFeed = fetchFeed
    }

    public func load() async {
        guard case .idle = state else { return }
        state = .loading
        currentPage = 1
        hasNextPage = true
        await performFetch(page: 1, appending: false)
    }

    public func loadMore() async {
        guard hasNextPage else { return }
        guard case .loaded(let existing) = state else { return }
        state = .loadingMore(existing)
        currentPage += 1
        await performFetch(page: currentPage, appending: true)
    }

    public func refresh() async {
        state = .idle
        await load()
    }

    private func performFetch(page: Int, appending: Bool) async {
        do {
            let feed = try await fetchFeed.execute(page: page)
            hasNextPage = feed.info.hasNextPage
            let incoming = feed.characters
            if appending, case .loadingMore(let existing) = state {
                state = .loaded(existing + incoming)
            } else {
                state = .loaded(incoming)
            }
        } catch {
            state = .error(error)
        }
    }
}
