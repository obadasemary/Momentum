public protocol FetchFeedUseCaseProtocol: Sendable {
    func execute(page: Int) async throws -> CharacterFeed
}

public final class FetchFeedUseCase: FetchFeedUseCaseProtocol {
    private let repository: any FeedRepositoryProtocol

    public init(repository: any FeedRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(page: Int) async throws -> CharacterFeed {
        try await repository.fetchCharacters(page: page)
    }
}
