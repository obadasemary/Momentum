// ── FILE: Packages/Domain/Sources/Domain/Entities/CharacterPageEntity.swift ──

public struct CharacterPageEntity: Sendable {
    public let totalCount: Int
    public let totalPages: Int
    public let characters: [CharacterEntity]

    public init(totalCount: Int, totalPages: Int, characters: [CharacterEntity]) {
        self.totalCount = totalCount
        self.totalPages = totalPages
        self.characters = characters
    }
}
