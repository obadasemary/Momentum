import SwiftUI
import Domain

public final class FeedBuilder {
    private let fetchFeed: any FetchFeedUseCaseProtocol

    public init(fetchFeed: any FetchFeedUseCaseProtocol) {
        self.fetchFeed = fetchFeed
    }

    public func buildView() -> some View {
        FeedView(viewModel: FeedViewModel(fetchFeed: fetchFeed))
    }
}
