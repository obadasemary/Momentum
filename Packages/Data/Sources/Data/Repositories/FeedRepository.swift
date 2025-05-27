import Core
import Domain

public final class FeedRepository: FeedRepositoryProtocol, @unchecked Sendable {
    private let networkService: any NetworkService

    public init(networkService: any NetworkService) {
        self.networkService = networkService
    }

    nonisolated public func fetchCharacters(page: Int) async throws -> CharacterFeed {
        let dto: CharacterFeedDTO = try await networkService.request(
            RickMortyEndpoint.characters(page: page)
        )
        return CharacterFeedMapper.toDomain(dto)
    }
}
