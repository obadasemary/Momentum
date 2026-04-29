// ── FILE: Packages/Domain/Sources/Domain/UseCases/ToDoUseCase.swift ──

import Foundation

public protocol ToDoUseCaseProtocol: Sendable {
    func fetchAll() async throws -> [ToDoEntity]
    func create(title: String, notes: String?) async throws -> ToDoEntity
    func update(_ todo: ToDoEntity) async throws
    func delete(_ id: UUID) async throws
    func toggleCompletion(_ id: UUID) async throws
}

public final class ToDoUseCase: ToDoUseCaseProtocol {

    private let repository: ToDoRepositoryProtocol

    public init(repository: ToDoRepositoryProtocol) {
        self.repository = repository
    }

    public func fetchAll() async throws -> [ToDoEntity] {
        try await repository.fetchAll()
    }

    public func create(title: String, notes: String?) async throws -> ToDoEntity {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw ToDoUseCaseError.emptyTitle
        }
        return try await repository.create(title: title, notes: notes)
    }

    public func update(_ todo: ToDoEntity) async throws {
        guard !todo.title.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw ToDoUseCaseError.emptyTitle
        }
        try await repository.update(todo)
    }

    public func delete(_ id: UUID) async throws {
        try await repository.delete(id)
    }

    public func toggleCompletion(_ id: UUID) async throws {
        try await repository.toggleCompletion(id)
    }
}
