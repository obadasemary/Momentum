import Foundation

public protocol ToDoRepositoryProtocol: Sendable {
    func fetchAll() async throws -> [ToDo]
    func create(title: String, notes: String?) async throws -> ToDo
    func update(_ todo: ToDo) async throws
    func delete(_ id: UUID) async throws
    func toggleCompletion(_ id: UUID) async throws
}
