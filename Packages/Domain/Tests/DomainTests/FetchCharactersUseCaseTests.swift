// ── FILE: Packages/Domain/Tests/DomainTests/FetchCharactersUseCaseTests.swift ──

import Testing
import Foundation
@testable import Domain

@Suite("FetchCharactersUseCase")
struct FetchCharactersUseCaseTests {

    @Test("Execute returns characters from repository on page 1")
    func executeReturnsCharacters() async throws {
        let expected = CharacterPageEntity(
            totalCount: 1,
            totalPages: 1,
            characters: [CharacterEntity(id: 1, name: "Rick", species: "Human", imageURL: nil)]
        )
        let repository = MockCharacterRepository()
        repository.stubbedResult = .success(expected)
        let sut = FetchCharactersUseCase(repository: repository)

        let result = try await sut.execute(page: 1)

        #expect(result.characters.count == 1)
        #expect(result.characters.first?.name == "Rick")
    }

    @Test("Execute propagates repository errors")
    func executePropagatesError() async throws {
        let repository = MockCharacterRepository()
        repository.stubbedResult = .failure(TestError.networkFailed)
        let sut = FetchCharactersUseCase(repository: repository)

        await #expect(throws: TestError.self) {
            _ = try await sut.execute(page: 1)
        }
    }

    @Test("Execute with page 2 passes page to repository")
    func executePassesPageToRepository() async throws {
        let repository = SpyCharacterRepository()
        let sut = FetchCharactersUseCase(repository: repository)

        _ = try await sut.execute(page: 2)

        #expect(repository.capturedPage == 2)
    }
}

private enum TestError: Error {
    case networkFailed
}

private final class SpyCharacterRepository: CharacterRepositoryProtocol {
    var capturedPage: Int?

    func fetchCharacters(page: Int) async throws -> CharacterPageEntity {
        capturedPage = page
        return CharacterPageEntity(totalCount: 0, totalPages: 1, characters: [])
    }
}
