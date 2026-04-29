// ── FILE: Packages/Domain/Sources/Domain/Entities/CharacterEntity.swift ──

import Foundation

public struct CharacterEntity: Identifiable, Equatable, Sendable {
    public let id: Int
    public let name: String
    public let species: String?
    public let imageURL: URL?

    public init(id: Int, name: String, species: String?, imageURL: URL?) {
        self.id = id
        self.name = name
        self.species = species
        self.imageURL = imageURL
    }
}
