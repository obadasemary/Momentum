public struct CharacterInfo: Sendable, Equatable {
    public let totalCount: Int
    public let totalPages: Int
    public let hasNextPage: Bool

    public init(totalCount: Int, totalPages: Int, hasNextPage: Bool) {
        self.totalCount = totalCount
        self.totalPages = totalPages
        self.hasNextPage = hasNextPage
    }
}
