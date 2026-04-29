import Foundation

extension URLRequest {
    public init(endpoint: some Endpoint) throws {
        var components = URLComponents(
            url: endpoint.baseURL.appending(path: endpoint.path),
            resolvingAgainstBaseURL: false
        )
        if !endpoint.queryParameters.isEmpty {
            components?.queryItems = endpoint.queryParameters
        }
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }
        self.init(url: url)
        httpMethod = endpoint.method.rawValue
        endpoint.headers.forEach { setValue($1, forHTTPHeaderField: $0) }
    }
}
