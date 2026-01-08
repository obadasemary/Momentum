import Foundation

protocol ToDoUseCaseProtocol {
    func fetchAll() async throws -> [ToDoEntity]
    func create(title: String, notes: String?) async throws -> ToDoEntity
    func update(_ todo: ToDoEntity) async throws
    func delete(_ id: UUID) async throws
    func toggleCompletion(_ id: UUID) async throws
}

final class ToDoUseCase {
    private let repository: ToDoRepositoryProtocol

    init(repository: ToDoRepositoryProtocol) {
        self.repository = repository
    }
}

extension ToDoUseCase: ToDoUseCaseProtocol {
    func fetchAll() async throws -> [ToDoEntity] {
        try await repository.fetchAll()
    }

    func create(title: String, notes: String?) async throws -> ToDoEntity {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw ToDoUseCaseError.emptyTitle
        }
        return try await repository.create(title: title, notes: notes)
    }

    func update(_ todo: ToDoEntity) async throws {
        guard !todo.title.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw ToDoUseCaseError.emptyTitle
        }
        try await repository.update(todo)
    }

    func delete(_ id: UUID) async throws {
        try await repository.delete(id)
    }

    func toggleCompletion(_ id: UUID) async throws {
        try await repository.toggleCompletion(id)
    }
}

enum ToDoUseCaseError: Error {
    case emptyTitle
}
