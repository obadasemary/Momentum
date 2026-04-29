import Foundation
import Core

public enum RickMortyEndpoint: Endpoint {
    case characters(page: Int)

    public var baseURL: URL {
        URL(string: "https://rickandmortyapi.com/api")!
    }

    public var path: String {
        switch self {
        case .characters: return "/character"
        }
    }

    public var method: HTTPMethod { .get }

    public var queryParameters: [URLQueryItem] {
        switch self {
        case .characters(let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        }
    }
}
