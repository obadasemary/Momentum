import Core
import Domain
import Data
import Presentation
import SwiftData

final class AppDIContainer {
    static let shared = AppDIContainer()
    private init() {}

    let imageCache = ImageCache()

    private lazy var networkService: any NetworkService =
        LoggingNetworkServiceDecorator(
            decoratee: URLSessionNetworkService()
        )

    func makeFeedBuilder() -> FeedBuilder {
        FeedBuilder(fetchFeed: FetchFeedUseCase(repository: makeFeedRepository()))
    }

    func makeToDoBuilder(modelContext: ModelContext) -> ToDoBuilder {
        ToDoBuilder(useCase: ToDoUseCase(repository: ToDoRepository(context: modelContext)))
    }

    private func makeFeedRepository() -> any FeedRepositoryProtocol {
        FeedRepository(networkService: networkService)
    }
}
