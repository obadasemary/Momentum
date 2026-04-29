// ── FILE: Packages/Data/Tests/DataTests/CharacterMapperTests.swift ──

import Testing
import Foundation
@testable import Data
import Domain

@Suite("CharacterMapper")
struct CharacterMapperTests {

    @Test("Maps CharacterResponseDTO to CharacterEntity correctly")
    func mapsCharacterDTO() {
        let imageURL = URL(string: "https://example.com/img.png")
        let dto = CharacterResponseDTO(id: 1, name: "Rick", species: "Human", image: imageURL)

        let entity = CharacterMapper.toEntity(dto)

        #expect(entity.id == 1)
        #expect(entity.name == "Rick")
        #expect(entity.species == "Human")
        #expect(entity.imageURL == imageURL)
    }

    @Test("Maps CharacterResponseDTO with nil species correctly")
    func mapsNilSpecies() {
        let dto = CharacterResponseDTO(id: 2, name: "Morty", species: nil, image: nil)

        let entity = CharacterMapper.toEntity(dto)

        #expect(entity.species == nil)
        #expect(entity.imageURL == nil)
    }

    @Test("Maps CharacterPageResponseDTO to CharacterPageEntity")
    func mapsPageDTO() {
        let dto = CharacterPageResponseDTO(
            info: InfoDTO(count: 826, pages: 42),
            results: [
                CharacterResponseDTO(id: 1, name: "Rick", species: "Human", image: nil),
                CharacterResponseDTO(id: 2, name: "Morty", species: "Human", image: nil)
            ]
        )

        let entity = CharacterMapper.toPageEntity(dto)

        #expect(entity.totalCount == 826)
        #expect(entity.totalPages == 42)
        #expect(entity.characters.count == 2)
    }

    @Test("Maps empty results to empty characters array")
    func mapsEmptyResults() {
        let dto = CharacterPageResponseDTO(info: InfoDTO(count: 0, pages: 0), results: [])

        let entity = CharacterMapper.toPageEntity(dto)

        #expect(entity.characters.isEmpty)
    }
}
