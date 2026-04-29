struct CharacterFeedDTO: Decodable, Sendable {
    let info: CharacterInfoDTO
    let results: [CharacterDTO]
}
