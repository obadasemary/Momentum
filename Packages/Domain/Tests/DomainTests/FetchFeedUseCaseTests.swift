import Testing
@testable import Domain

@Suite("FetchFeedUseCase")
struct FetchFeedUseCaseTests {

    @Test("Returns characters from repository")
    func returnsCharactersFromRepository() async throws {
        let mock = MockFeedRepository()
        mock.stubbedResult = .success(.fixture(characters: [.fixture(id: 1), .fixture(id: 2)]))
        let sut = FetchFeedUseCase(repository: mock)

        let feed = try await sut.execute(page: 1)

        #expect(feed.characters.count == 2)
        #expect(feed.characters[0].id == 1)
    }

    @Test("Propagates repository errors")
    func propagatesErrors() async throws {
        let mock = MockFeedRepository()
        mock.stubbedResult = .failure(MockError.stub)
        let sut = FetchFeedUseCase(repository: mock)

        await #expect(throws: MockError.self) {
            _ = try await sut.execute(page: 1)
        }
    }
}

private enum MockError: Error { case stub }
