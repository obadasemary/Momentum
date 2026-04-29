// ── FILE: Packages/Data/Tests/DataTests/Mocks/MockNetworkClient.swift ──

import Foundation
import Core

final class MockNetworkClient: NetworkClientProtocol {

    var stubbedData: (any Sendable)?
    var stubbedError: Error?

    func send<T: Decodable & Sendable>(_ request: URLRequest) async throws -> T {
        if let error = stubbedError {
            throw error
        }
        guard let data = stubbedData as? T else {
            throw MockError.typeMismatch
        }
        return data
    }

    enum MockError: Error {
        case typeMismatch
    }
}
