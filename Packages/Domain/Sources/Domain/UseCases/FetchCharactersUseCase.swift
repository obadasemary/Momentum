// ── FILE: Packages/Domain/Sources/Domain/UseCases/FetchCharactersUseCase.swift ──

public protocol FetchCharactersUseCaseProtocol: Sendable {
    func execute(page: Int) async throws -> CharacterPageEntity
}

public final class FetchCharactersUseCase: FetchCharactersUseCaseProtocol {

    private let repository: CharacterRepositoryProtocol

    public init(repository: CharacterRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(page: Int) async throws -> CharacterPageEntity {
        try await repository.fetchCharacters(page: page)
    }
}
