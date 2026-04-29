// ── FILE: Packages/Data/Sources/Data/DTOs/CharacterPageResponseDTO.swift ──

import Foundation

struct CharacterPageResponseDTO: Decodable, Sendable {
    let info: InfoDTO
    let results: [CharacterResponseDTO]
}

struct InfoDTO: Decodable, Sendable {
    let count: Int
    let pages: Int
}
