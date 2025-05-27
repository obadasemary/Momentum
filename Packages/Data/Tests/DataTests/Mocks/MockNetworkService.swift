import Foundation
import Core

final class MockNetworkService: NetworkService, @unchecked Sendable {
    var stubbedResult: Any?
    var stubbedError: Error?
    private(set) var lastRequestedPath: String?

    func request<T: Decodable & Sendable>(_ endpoint: some Endpoint) async throws -> T {
        lastRequestedPath = endpoint.path
        if let error = stubbedError { throw error }
        guard let result = stubbedResult as? T else {
            throw NetworkError.decodingFailed(
                DecodingError.typeMismatch(
                    T.self,
                    DecodingError.Context(codingPath: [], debugDescription: "Mock type mismatch")
                )
            )
        }
        return result
    }
}
