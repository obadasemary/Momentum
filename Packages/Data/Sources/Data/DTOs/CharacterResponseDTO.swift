// ── FILE: Packages/Data/Sources/Data/DTOs/CharacterResponseDTO.swift ──

import Foundation

struct CharacterResponseDTO: Decodable, Sendable {
    let id: Int
    let name: String
    let species: String?
    let image: URL?
}
