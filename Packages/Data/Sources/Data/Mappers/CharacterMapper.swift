import Foundation
import Domain

enum CharacterMapper {
    static func toDomain(_ dto: CharacterDTO) -> Domain.Character {
        let imageURL = dto.image.flatMap { URL(string: $0) }
        return Domain.Character(
            id: dto.id,
            name: dto.name,
            species: dto.species ?? "Unknown",
            imageURL: imageURL
        )
    }
}
