import Foundation
@testable import Domain

extension Character {
    static func fixture(
        id: Int = 1,
        name: String = "Rick Sanchez",
        species: String = "Human",
        imageURL: URL? = URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
    ) -> Character {
        Character(id: id, name: name, species: species, imageURL: imageURL)
    }
}

extension CharacterFeed {
    static func fixture(
        characters: [Character] = [.fixture()],
        totalCount: Int = 1,
        totalPages: Int = 1,
        hasNextPage: Bool = false
    ) -> CharacterFeed {
        CharacterFeed(
            info: CharacterInfo(totalCount: totalCount, totalPages: totalPages, hasNextPage: hasNextPage),
            characters: characters
        )
    }
}
