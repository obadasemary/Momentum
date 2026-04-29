import Foundation

public protocol Endpoint: Sendable {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryParameters: [URLQueryItem] { get }
}

public extension Endpoint {
    var headers: [String: String] { [:] }
    var queryParameters: [URLQueryItem] { [] }
}
