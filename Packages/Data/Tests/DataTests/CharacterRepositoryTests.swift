// ── FILE: Packages/Data/Tests/DataTests/CharacterRepositoryTests.swift ──

import Testing
import Foundation
@testable import Data
import Core
import Domain

@Suite("CharacterDataRepository")
struct CharacterDataRepositoryTests {

    @Test("Fetch characters returns mapped entities from network")
    func fetchCharactersReturnsMappedEntities() async throws {
        let dto = CharacterPageResponseDTO(
            info: InfoDTO(count: 1, pages: 1),
            results: [CharacterResponseDTO(id: 42, name: "Rick", species: "Human", image: nil)]
        )
        let client = MockNetworkClient()
        client.stubbedData = dto
        let sut = CharacterDataRepository(networkClient: client)

        let page = try await sut.fetchCharacters(page: 1)

        #expect(page.characters.count == 1)
        #expect(page.characters.first?.id == 42)
        #expect(page.characters.first?.name == "Rick")
    }

    @Test("Fetch characters propagates network error")
    func fetchCharactersPropagatesError() async throws {
        let client = MockNetworkClient()
        client.stubbedError = NetworkError.invalidResponse(statusCode: 500)
        let sut = CharacterDataRepository(networkClient: client)

        await #expect(throws: NetworkError.self) {
            _ = try await sut.fetchCharacters(page: 1)
        }
    }

    @Test("Fetch characters with page 2 builds correct URL")
    func fetchCharactersPage2BuildsURL() async throws {
        let dto = CharacterPageResponseDTO(info: InfoDTO(count: 0, pages: 1), results: [])
        let spy = URLSpyNetworkClient(result: dto)
        let sut = CharacterDataRepository(networkClient: spy)

        _ = try await sut.fetchCharacters(page: 2)

        let url = try #require(spy.capturedRequest?.url)
        #expect(url.absoluteString.contains("page=2"))
    }
}

private final class URLSpyNetworkClient: NetworkClientProtocol {
    var capturedRequest: URLRequest?
    private let result: CharacterPageResponseDTO

    init(result: CharacterPageResponseDTO) {
        self.result = result
    }

    func send<T: Decodable & Sendable>(_ request: URLRequest) async throws -> T {
        capturedRequest = request
        guard let typed = result as? T else {
            throw MockError.typeMismatch
        }
        return typed
    }

    enum MockError: Error { case typeMismatch }
}
