import Foundation

// URLSession is documented as thread-safe and immutable after init — @unchecked Sendable is safe.
public final class URLSessionNetworkService: NetworkService, @unchecked Sendable {
    private let session: URLSession

    public init(session: URLSession = .shared) {
        self.session = session
    }

    nonisolated public func request<T: Decodable & Sendable>(_ endpoint: some Endpoint) async throws -> T {
        let urlRequest = try URLRequest(endpoint: endpoint)
        let (data, response) = try await session.data(for: urlRequest)
        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw NetworkError.invalidResponse(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0)
        }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let error as DecodingError {
            throw NetworkError.decodingFailed(error)
        }
    }
}
