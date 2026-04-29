// ── FILE: Packages/Domain/Sources/Domain/Repositories/CharacterRepositoryProtocol.swift ──

public protocol CharacterRepositoryProtocol: Sendable {
    func fetchCharacters(page: Int) async throws -> CharacterPageEntity
}
