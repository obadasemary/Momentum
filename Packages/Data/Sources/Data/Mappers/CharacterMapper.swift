// ── FILE: Packages/Data/Sources/Data/Mappers/CharacterMapper.swift ──

import Domain

enum CharacterMapper {

    static func toEntity(_ dto: CharacterResponseDTO) -> CharacterEntity {
        CharacterEntity(
            id: dto.id,
            name: dto.name,
            species: dto.species,
            imageURL: dto.image
        )
    }

    static func toPageEntity(_ dto: CharacterPageResponseDTO) -> CharacterPageEntity {
        CharacterPageEntity(
            totalCount: dto.info.count,
            totalPages: dto.info.pages,
            characters: dto.results.map(toEntity)
        )
    }
}
