import Foundation

struct CharacterDTO: Decodable, Sendable {
    let id: Int
    let name: String
    let species: String?
    let image: String?
}
