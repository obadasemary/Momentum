public protocol FeedRepositoryProtocol: Sendable {
    func fetchCharacters(page: Int) async throws -> CharacterFeed
}
