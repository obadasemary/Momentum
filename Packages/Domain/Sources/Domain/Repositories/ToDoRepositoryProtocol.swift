// ── FILE: Packages/Domain/Sources/Domain/Repositories/ToDoRepositoryProtocol.swift ──

import Foundation

public protocol ToDoRepositoryProtocol: Sendable {
    func fetchAll() async throws -> [ToDoEntity]
    func create(title: String, notes: String?) async throws -> ToDoEntity
    func update(_ todo: ToDoEntity) async throws
    func delete(_ id: UUID) async throws
    func toggleCompletion(_ id: UUID) async throws
}
