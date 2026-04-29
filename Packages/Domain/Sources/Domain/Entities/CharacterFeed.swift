public struct CharacterFeed: Sendable, Equatable {
    public let info: CharacterInfo
    public let characters: [Character]

    public init(info: CharacterInfo, characters: [Character]) {
        self.info = info
        self.characters = characters
    }
}
