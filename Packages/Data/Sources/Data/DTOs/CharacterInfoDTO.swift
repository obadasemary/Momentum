struct CharacterInfoDTO: Decodable, Sendable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
