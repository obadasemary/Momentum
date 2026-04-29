// Decorator pattern: wraps any NetworkService to add debug logging without modifying the decoratee.
public final class LoggingNetworkServiceDecorator: NetworkService, @unchecked Sendable {
    private let decoratee: any NetworkService

    public init(decoratee: any NetworkService) {
        self.decoratee = decoratee
    }

    nonisolated public func request<T: Decodable & Sendable>(_ endpoint: some Endpoint) async throws -> T {
        #if DEBUG
        print("[Network] --> \(endpoint.method.rawValue) \(endpoint.baseURL.absoluteString)\(endpoint.path)")
        #endif
        do {
            let result: T = try await decoratee.request(endpoint)
            #if DEBUG
            print("[Network] <-- \(endpoint.path) 2xx OK")
            #endif
            return result
        } catch {
            #if DEBUG
            print("[Network] <-- \(endpoint.path) ERROR: \(error)")
            #endif
            throw error
        }
    }
}
