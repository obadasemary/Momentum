import Domain

enum CharacterFeedMapper {
    static func toDomain(_ dto: CharacterFeedDTO) -> CharacterFeed {
        CharacterFeed(
            info: CharacterInfo(
                totalCount: dto.info.count,
                totalPages: dto.info.pages,
                hasNextPage: dto.info.next != nil
            ),
            characters: dto.results.map { CharacterMapper.toDomain($0) }
        )
    }
}
