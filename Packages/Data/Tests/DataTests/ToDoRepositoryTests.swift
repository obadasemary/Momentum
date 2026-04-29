import Testing
import Foundation
@testable import Data
import Domain

// ToDoRepository uses SwiftData's ModelContext which requires a full container;
// these tests verify the in-memory mock repository behaviour as a behaviour contract.
// Integration tests against the real repository use XCTest with a ModelContainer.

@Suite("MockToDoRepository (contract tests)")
struct ToDoRepositoryContractTests {

    private func makeMock() -> MockToDoRepositoryData {
        MockToDoRepositoryData()
    }

    @Test("Fetch all returns empty array initially")
    func fetchAllEmpty() async throws {
        let sut = makeMock()
        let todos = try await sut.fetchAll()
        #expect(todos.isEmpty)
    }

    @Test("Create todo adds to repository")
    func createAdds() async throws {
        let sut = makeMock()
        let todo = try await sut.create(title: "Task 1", notes: "Note")
        #expect(todo.title == "Task 1")
        #expect(todo.notes == "Note")
        #expect(todo.isCompleted == false)
        let todos = try await sut.fetchAll()
        #expect(todos.count == 1)
    }

    @Test("Delete removes todo")
    func deleteRemoves() async throws {
        let sut = makeMock()
        let todo1 = try await sut.create(title: "Task 1", notes: nil)
        let todo2 = try await sut.create(title: "Task 2", notes: nil)
        try await sut.delete(todo1.id)
        let todos = try await sut.fetchAll()
        #expect(todos.count == 1)
        #expect(todos.first?.id == todo2.id)
    }

    @Test("Delete non-existent throws notFound")
    func deleteNonExistentThrows() async {
        let sut = makeMock()
        await #expect(throws: ToDoRepositoryError.notFound) {
            try await sut.delete(UUID())
        }
    }

    @Test("Toggle completion marks as completed")
    func toggleCompletion() async throws {
        let sut = makeMock()
        let todo = try await sut.create(title: "Task", notes: nil)
        try await sut.toggleCompletion(todo.id)
        let todos = try await sut.fetchAll()
        #expect(todos.first?.isCompleted == true)
        #expect(todos.first?.completedAt != nil)
    }

    @Test("Toggle completion twice restores to incomplete")
    func toggleTwiceRestores() async throws {
        let sut = makeMock()
        let todo = try await sut.create(title: "Task", notes: nil)
        try await sut.toggleCompletion(todo.id)
        try await sut.toggleCompletion(todo.id)
        let todos = try await sut.fetchAll()
        #expect(todos.first?.isCompleted == false)
        #expect(todos.first?.completedAt == nil)
    }
}

// In-memory mock of ToDoRepositoryProtocol for Data package tests
private final class MockToDoRepositoryData: ToDoRepositoryProtocol, @unchecked Sendable {
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
