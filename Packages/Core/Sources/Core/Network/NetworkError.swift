// ── FILE: Packages/Core/Sources/Core/Network/NetworkError.swift ──

import Foundation

public enum NetworkError: Error, LocalizedError {
    case invalidResponse(statusCode: Int)
    case decodingFailed(Error)
    case requestFailed(Error)

    public var errorDescription: String? {
        switch self {
        case .invalidResponse(let code):
            return "Server returned status code \(code)"
        case .decodingFailed:
            return "Failed to decode the server response"
        case .requestFailed(let error):
            return error.localizedDescription
        }
    }
}
