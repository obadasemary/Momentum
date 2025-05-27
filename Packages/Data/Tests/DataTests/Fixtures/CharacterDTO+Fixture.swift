@testable import Data

extension CharacterDTO {
    static func fixture(
        id: Int = 1,
        name: String = "Rick Sanchez",
        species: String? = "Human",
        image: String? = "https://rickandmortyapi.com/api/character/avatar/1.jpeg"
    ) -> CharacterDTO {
        CharacterDTO(id: id, name: name, species: species, image: image)
    }
}

extension CharacterFeedDTO {
    static func fixture(
        count: Int = 1,
        pages: Int = 1,
        characters: [CharacterDTO] = [.fixture()]
    ) -> CharacterFeedDTO {
        CharacterFeedDTO(
            info: CharacterInfoDTO(count: count, pages: pages, next: nil, prev: nil),
            results: characters
        )
    }
}
