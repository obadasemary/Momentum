// ── FILE: Packages/Domain/Tests/DomainTests/ToDoUseCaseTests.swift ──

import Testing
import Foundation
@testable import Domain

@Suite("ToDoUseCase")
struct ToDoUseCaseTests {

    @Test("Fetch all returns repository data")
    func fetchAllReturnsRepositoryData() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        _ = try await repository.create(title: "Task 1", notes: "Note 1")
        _ = try await repository.create(title: "Task 2", notes: nil)

        let todos = try await sut.fetchAll()
        #expect(todos.count == 2)
    }

    @Test("Create with valid title succeeds")
    func createWithValidTitleSucceeds() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        let todo = try await sut.create(title: "Valid Task", notes: "Note")

        #expect(todo.title == "Valid Task")
        #expect(todo.notes == "Note")
        #expect(todo.isCompleted == false)
    }

    @Test("Create with empty title throws emptyTitle error")
    func createWithEmptyTitleThrowsError() async {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        await #expect(throws: ToDoUseCaseError.emptyTitle) {
            _ = try await sut.create(title: "", notes: nil)
        }
    }

    @Test("Create with whitespace-only title throws emptyTitle error")
    func createWithWhitespaceTitleThrowsError() async {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        await #expect(throws: ToDoUseCaseError.emptyTitle) {
            _ = try await sut.create(title: "   ", notes: nil)
        }
    }

    @Test("Update with valid data succeeds")
    func updateWithValidDataSucceeds() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        var todo = try await sut.create(title: "Original", notes: nil)
        todo.title = "Updated"

        try await sut.update(todo)

        let todos = try await sut.fetchAll()
        #expect(todos.first?.title == "Updated")
    }

    @Test("Update with empty title throws emptyTitle error")
    func updateWithEmptyTitleThrowsError() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        var todo = try await sut.create(title: "Original", notes: nil)
        todo.title = ""

        await #expect(throws: ToDoUseCaseError.emptyTitle) {
            try await sut.update(todo)
        }
    }

    @Test("Delete removes todo from repository")
    func deleteRemovesTodo() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        let todo = try await sut.create(title: "Task", notes: nil)
        try await sut.delete(todo.id)

        let todos = try await sut.fetchAll()
        #expect(todos.isEmpty)
    }

    @Test("Delete non-existent todo throws notFound error")
    func deleteNonExistentThrowsError() async {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        await #expect(throws: ToDoRepositoryError.notFound) {
            try await sut.delete(UUID())
        }
    }

    @Test("Toggle completion changes completion state")
    func toggleCompletionChangesState() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        let todo = try await sut.create(title: "Task", notes: nil)
        try await sut.toggleCompletion(todo.id)

        let todos = try await sut.fetchAll()
        #expect(todos.first?.isCompleted == true)
        #expect(todos.first?.completedAt != nil)
    }

    @Test("Toggle completion twice returns to original state")
    func toggleCompletionTwiceRestoresState() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        let todo = try await sut.create(title: "Task", notes: nil)
        try await sut.toggleCompletion(todo.id)
        try await sut.toggleCompletion(todo.id)

        let todos = try await sut.fetchAll()
        #expect(todos.first?.isCompleted == false)
        #expect(todos.first?.completedAt == nil)
    }

    @Test("Created todos have unique IDs")
    func createdTodosHaveUniqueIDs() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        let t1 = try await sut.create(title: "Task 1", notes: nil)
        let t2 = try await sut.create(title: "Task 2", notes: nil)
        let t3 = try await sut.create(title: "Task 3", notes: nil)

        #expect(t1.id != t2.id)
        #expect(t2.id != t3.id)
        #expect(t1.id != t3.id)
    }
}
