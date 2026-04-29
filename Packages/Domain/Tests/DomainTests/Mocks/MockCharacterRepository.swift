// ── FILE: Packages/Domain/Tests/DomainTests/Mocks/MockCharacterRepository.swift ──

import Foundation
@testable import Domain

final class MockCharacterRepository: CharacterRepositoryProtocol {

    var stubbedResult: Result<CharacterPageEntity, Error> = .success(
        CharacterPageEntity(totalCount: 0, totalPages: 1, characters: [])
    )

    func fetchCharacters(page: Int) async throws -> CharacterPageEntity {
        try stubbedResult.get()
    }
}
