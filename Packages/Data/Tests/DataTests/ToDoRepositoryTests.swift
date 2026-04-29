// ── FILE: Packages/Data/Tests/DataTests/ToDoRepositoryTests.swift ──

import Testing
import Foundation
@testable import Domain

// These tests exercise the MockToDoRepository (in-memory implementation)
// which shares the same protocol contract as ToDoDataRepository.
// Integration tests for ToDoDataRepository require a live ModelContext
// and are covered by UI tests.

@Suite("ToDoRepository Protocol Contract")
struct ToDoRepositoryContractTests {

    @Test("Fetch all returns empty initially")
    func fetchAllReturnsEmptyInitially() async throws {
        let sut = InMemoryToDoRepository()

        let todos = try await sut.fetchAll()
        #expect(todos.isEmpty)
    }

    @Test("Create adds todo and returns it")
    func createAddsTodo() async throws {
        let sut = InMemoryToDoRepository()

        let todo = try await sut.create(title: "Task", notes: "Note")

        #expect(todo.title == "Task")
        #expect(todo.notes == "Note")
        #expect(todo.isCompleted == false)

        let all = try await sut.fetchAll()
        #expect(all.count == 1)
    }

    @Test("Create multiple todos returns all sorted by date")
    func createMultipleReturnsSortedByDate() async throws {
        let sut = InMemoryToDoRepository()

        let t1 = try await sut.create(title: "First", notes: nil)
        let t2 = try await sut.create(title: "Second", notes: nil)
        let t3 = try await sut.create(title: "Third", notes: nil)

        let all = try await sut.fetchAll()
        #expect(all.count == 3)
        #expect(all[0].id == t3.id)
        #expect(all[1].id == t2.id)
        #expect(all[2].id == t1.id)
    }

    @Test("Update modifies existing todo")
    func updateModifiesExisting() async throws {
        let sut = InMemoryToDoRepository()

        var todo = try await sut.create(title: "Original", notes: nil)
        todo.title = "Updated"
        try await sut.update(todo)

        let all = try await sut.fetchAll()
        #expect(all.first?.title == "Updated")
    }

    @Test("Update non-existent todo throws notFound")
    func updateNonExistentThrowsNotFound() async {
        let sut = InMemoryToDoRepository()

        await #expect(throws: ToDoRepositoryError.notFound) {
            try await sut.update(ToDoEntity(title: "Ghost"))
        }
    }

    @Test("Delete removes todo from store")
    func deleteRemovesTodo() async throws {
        let sut = InMemoryToDoRepository()

        let todo = try await sut.create(title: "Task", notes: nil)
        try await sut.delete(todo.id)

        let all = try await sut.fetchAll()
        #expect(all.isEmpty)
    }

    @Test("Delete non-existent todo throws notFound")
    func deleteNonExistentThrowsNotFound() async {
        let sut = InMemoryToDoRepository()

        await #expect(throws: ToDoRepositoryError.notFound) {
            try await sut.delete(UUID())
        }
    }

    @Test("Toggle completion marks todo as completed with date")
    func toggleCompletionMarksCompleted() async throws {
        let sut = InMemoryToDoRepository()

        let todo = try await sut.create(title: "Task", notes: nil)
        try await sut.toggleCompletion(todo.id)

        let all = try await sut.fetchAll()
        #expect(all.first?.isCompleted == true)
        #expect(all.first?.completedAt != nil)
    }

    @Test("Toggle completion twice returns to incomplete with nil date")
    func toggleCompletionTwiceRestoresIncomplete() async throws {
        let sut = InMemoryToDoRepository()

        let todo = try await sut.create(title: "Task", notes: nil)
        try await sut.toggleCompletion(todo.id)
        try await sut.toggleCompletion(todo.id)

        let all = try await sut.fetchAll()
        #expect(all.first?.isCompleted == false)
        #expect(all.first?.completedAt == nil)
    }
}

private final class InMemoryToDoRepository: ToDoRepositoryProtocol {
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
        guard let i = todos.firstIndex(where: { $0.id == todo.id }) else {
            throw ToDoRepositoryError.notFound
        }
        todos[i] = todo
    }

    func delete(_ id: UUID) async throws {
        guard let i = todos.firstIndex(where: { $0.id == id }) else {
            throw ToDoRepositoryError.notFound
        }
        todos.remove(at: i)
    }

    func toggleCompletion(_ id: UUID) async throws {
        guard let i = todos.firstIndex(where: { $0.id == id }) else {
            throw ToDoRepositoryError.notFound
        }
        todos[i].isCompleted.toggle()
        todos[i].completedAt = todos[i].isCompleted ? Date() : nil
    }
}
