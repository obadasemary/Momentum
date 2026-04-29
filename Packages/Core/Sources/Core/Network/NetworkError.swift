import Foundation

public enum NetworkError: Error, Sendable {
    case invalidURL
    case invalidResponse(statusCode: Int)
    case decodingFailed(DecodingError)
    case underlying(any Error & Sendable)
}
