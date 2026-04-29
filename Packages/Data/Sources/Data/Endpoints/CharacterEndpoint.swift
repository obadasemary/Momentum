// ── FILE: Packages/Data/Sources/Data/Endpoints/CharacterEndpoint.swift ──

import Foundation

enum CharacterEndpoint {

    static let baseURL = "https://rickandmortyapi.com/api/character"

    static func characters(page: Int) throws -> URLRequest {
        guard var components = URLComponents(string: baseURL) else {
            throw CharacterEndpointError.invalidBaseURL
        }
        components.queryItems = [URLQueryItem(name: "page", value: "\(page)")]
        guard let url = components.url else {
            throw CharacterEndpointError.invalidURL
        }
        return URLRequest(url: url)
    }
}

enum CharacterEndpointError: Error {
    case invalidBaseURL
    case invalidURL
}
