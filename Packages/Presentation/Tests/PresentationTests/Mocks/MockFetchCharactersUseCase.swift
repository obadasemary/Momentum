// ── FILE: Packages/Presentation/Tests/PresentationTests/Mocks/MockFetchCharactersUseCase.swift ──

import Domain
@testable import Presentation

final class MockFetchCharactersUseCase: FetchCharactersUseCaseProtocol {

    var stubbedResult: Result<CharacterPageEntity, Error> = .success(
        CharacterPageEntity(totalCount: 0, totalPages: 1, characters: [])
    )

    func execute(page: Int) async throws -> CharacterPageEntity {
        try stubbedResult.get()
    }
}
