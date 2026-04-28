public protocol NetworkService: Sendable {
    func request<T: Decodable & Sendable>(_ endpoint: some Endpoint) async throws -> T
}
