import Foundation
@testable import Domain

final class MockFeedRepository: FeedRepositoryProtocol, @unchecked Sendable {
    var stubbedResult: Result<CharacterFeed, Error> = .success(.fixture())

    func fetchCharacters(page: Int) async throws -> CharacterFeed {
        try stubbedResult.get()
    }
}
