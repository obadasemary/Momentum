// ── FILE: Packages/Core/Sources/Core/Network/NetworkClientProtocol.swift ──

import Foundation

public protocol NetworkClientProtocol: Sendable {
    func send<T: Decodable & Sendable>(_ request: URLRequest) async throws -> T
}
