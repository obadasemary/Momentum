import Testing
import Foundation
@testable import Data
import Domain

@Suite("CharacterMapper")
struct CharacterMapperTests {

    @Test("Maps id and name correctly")
    func mapsIdAndName() {
        let dto = CharacterDTO.fixture(id: 42, name: "Morty Smith")
        let character = CharacterMapper.toDomain(dto)
        #expect(character.id == 42)
        #expect(character.name == "Morty Smith")
    }

    @Test("Maps species or falls back to Unknown")
    func mapsSpeciesWithFallback() {
        let withSpecies = CharacterMapper.toDomain(CharacterDTO.fixture(species: "Alien"))
        let withoutSpecies = CharacterMapper.toDomain(CharacterDTO.fixture(species: nil))
        #expect(withSpecies.species == "Alien")
        #expect(withoutSpecies.species == "Unknown")
    }

    @Test("Parses valid image URL")
    func parsesValidImageURL() {
        let dto = CharacterDTO.fixture(image: "https://example.com/avatar.jpeg")
        let character = CharacterMapper.toDomain(dto)
        #expect(character.imageURL?.absoluteString == "https://example.com/avatar.jpeg")
    }

    @Test("Sets imageURL to nil for missing image")
    func setsNilForMissingImage() {
        let dto = CharacterDTO.fixture(image: nil)
        let character = CharacterMapper.toDomain(dto)
        #expect(character.imageURL == nil)
    }
}
