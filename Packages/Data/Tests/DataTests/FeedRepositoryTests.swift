import Testing
import Foundation
@testable import Data
import Domain
import Core

@Suite("FeedRepository")
struct FeedRepositoryTests {

    @Test("Fetches and maps characters from network")
    func fetchesAndMapsCharacters() async throws {
        let mock = MockNetworkService()
        mock.stubbedResult = CharacterFeedDTO.fixture(
            count: 826,
            pages: 42,
            characters: [.fixture(id: 1, name: "Rick Sanchez")]
        )
        let sut = FeedRepository(networkService: mock)

        let feed = try await sut.fetchCharacters(page: 1)

        #expect(feed.characters.count == 1)
        #expect(feed.characters[0].name == "Rick Sanchez")
        #expect(feed.info.totalCount == 826)
        #expect(feed.info.totalPages == 42)
    }

    @Test("Sends correct page query parameter")
    func sendsCorrectPage() async throws {
        let mock = MockNetworkService()
        mock.stubbedResult = CharacterFeedDTO.fixture()
        let sut = FeedRepository(networkService: mock)

        _ = try await sut.fetchCharacters(page: 3)

        #expect(mock.lastRequestedPath == "/character")
    }

    @Test("Propagates network errors")
    func propagatesNetworkErrors() async throws {
        let mock = MockNetworkService()
        mock.stubbedError = NetworkError.invalidResponse(statusCode: 503)
        let sut = FeedRepository(networkService: mock)

        await #expect(throws: NetworkError.self) {
            _ = try await sut.fetchCharacters(page: 1)
        }
    }
}
