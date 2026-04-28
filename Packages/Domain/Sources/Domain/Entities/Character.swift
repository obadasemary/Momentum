import Foundation

public struct Character: Sendable, Identifiable, Equatable, Hashable {
    public let id: Int
    public let name: String
    public let species: String
    public let imageURL: URL?

    public init(id: Int, name: String, species: String, imageURL: URL?) {
        self.id = id
        self.name = name
        self.species = species
        self.imageURL = imageURL
    }
}
