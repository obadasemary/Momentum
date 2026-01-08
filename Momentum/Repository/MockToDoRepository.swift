import Foundation

final class MockToDoRepository: ToDoRepositoryProtocol {
    private var todos: [ToDoEntity] = []

    func fetchAll() async throws -> [ToDoEntity] {
        todos.sorted { $0.createdAt > $1.createdAt }
    }

    func create(title: String, notes: String?) async throws -> ToDoEntity {
        let todo = ToDoEntity(title: title, notes: notes)
        todos.append(todo)
        return todo
    }

    func update(_ todo: ToDoEntity) async throws {
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
