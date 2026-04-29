import Foundation

public protocol ToDoUseCaseProtocol: Sendable {
    func fetchAll() async throws -> [ToDo]
    func create(title: String, notes: String?) async throws -> ToDo
    func update(_ todo: ToDo) async throws
    func delete(_ id: UUID) async throws
    func toggleCompletion(_ id: UUID) async throws
}

public final class ToDoUseCase: ToDoUseCaseProtocol {
    private let repository: any ToDoRepositoryProtocol

    public init(repository: any ToDoRepositoryProtocol) {
        self.repository = repository
    }

    public func fetchAll() async throws -> [ToDo] {
        try await repository.fetchAll()
    }

    public func create(title: String, notes: String?) async throws -> ToDo {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw ToDoUseCaseError.emptyTitle
        }
        return try await repository.create(title: title, notes: notes)
    }

    public func update(_ todo: ToDo) async throws {
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

public enum ToDoUseCaseError: Error, Sendable {
    case emptyTitle
}
