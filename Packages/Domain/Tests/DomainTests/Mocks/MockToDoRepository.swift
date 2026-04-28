import Foundation
@testable import Domain

final class MockToDoRepository: ToDoRepositoryProtocol, @unchecked Sendable {
    private var todos: [ToDo] = []

    func fetchAll() async throws -> [ToDo] {
        todos.sorted { $0.createdAt > $1.createdAt }
    }

    func create(title: String, notes: String?) async throws -> ToDo {
        let todo = ToDo(title: title, notes: notes)
        todos.append(todo)
        return todo
    }

    func update(_ todo: ToDo) async throws {
        guard let index = todos.firstIndex(where: { $0.id == todo.id }) else {
            throw ToDoRepositoryError.notFound
        }
        todos[index] = todo
    }

    func delete(_ id: UUID) async throws {
        guard let index = todos.firstIndex(where: { $0.id == id }) else {
            throw ToDoRepositoryError.notFound
        }
        todos.remove(at: index)
    }

    func toggleCompletion(_ id: UUID) async throws {
        guard let index = todos.firstIndex(where: { $0.id == id }) else {
            throw ToDoRepositoryError.notFound
        }
        todos[index].isCompleted.toggle()
        todos[index].completedAt = todos[index].isCompleted ? Date() : nil
    }
}

public enum ToDoRepositoryError: Error, Sendable {
    case notFound
}
