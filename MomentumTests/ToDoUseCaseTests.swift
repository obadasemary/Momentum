import Testing
import Foundation
@testable import Momentum

struct ToDoUseCaseTests {

    @MainActor
    @Test("Fetch all todos returns repository data")
    func fetchAllReturnsRepositoryData() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        _ = try await repository.create(title: "Task 1", notes: "Note 1")
        _ = try await repository.create(title: "Task 2", notes: nil)

        let todos = try await sut.fetchAll()

        #expect(todos.count == 2)
    }

    @MainActor
    @Test("Create todo with valid title succeeds")
    func createTodoWithValidTitleSucceeds() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        let todo = try await sut.create(title: "Valid Task", notes: "Valid Note")

        #expect(todo.title == "Valid Task")
        #expect(todo.notes == "Valid Note")
        #expect(todo.isCompleted == false)
        #expect(todo.completedAt == nil)
    }

    @MainActor
    @Test("Create todo with empty title throws error")
    func createTodoWithEmptyTitleThrowsError() async {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        await #expect(throws: ToDoUseCaseError.emptyTitle) {
            _ = try await sut.create(title: "", notes: "Note")
        }
    }

    @MainActor
    @Test("Create todo with whitespace-only title throws error")
    func createTodoWithWhitespaceOnlyTitleThrowsError() async {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        await #expect(throws: ToDoUseCaseError.emptyTitle) {
            _ = try await sut.create(title: "   ", notes: "Note")
        }
    }

    @MainActor
    @Test("Create todo without notes succeeds")
    func createTodoWithoutNotesSucceeds() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        let todo = try await sut.create(title: "Task", notes: nil)

        #expect(todo.title == "Task")
        #expect(todo.notes == nil)
    }

    @MainActor
    @Test("Update todo with valid data succeeds")
    func updateTodoWithValidDataSucceeds() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        var todo = try await sut.create(title: "Original", notes: "Original Note")
        todo.title = "Updated"
        todo.notes = "Updated Note"

        try await sut.update(todo)

        let todos = try await sut.fetchAll()
        #expect(todos.first?.title == "Updated")
        #expect(todos.first?.notes == "Updated Note")
    }

    @MainActor
    @Test("Update todo with empty title throws error")
    func updateTodoWithEmptyTitleThrowsError() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        var todo = try await sut.create(title: "Original", notes: nil)
        todo.title = ""

        await #expect(throws: ToDoUseCaseError.emptyTitle) {
            try await sut.update(todo)
        }
    }

    @MainActor
    @Test("Update non-existent todo throws error")
    func updateNonExistentTodoThrowsError() async {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        let nonExistentTodo = ToDoEntity(title: "Non-existent")

        await #expect(throws: ToDoRepositoryError.notFound) {
            try await sut.update(nonExistentTodo)
        }
    }

    @MainActor
    @Test("Delete todo removes it from repository")
    func deleteTodoRemovesFromRepository() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        let todo = try await sut.create(title: "Task", notes: nil)

        var todos = try await sut.fetchAll()
        #expect(todos.count == 1)

        try await sut.delete(todo.id)

        todos = try await sut.fetchAll()
        #expect(todos.isEmpty)
    }

    @MainActor
    @Test("Delete non-existent todo throws error")
    func deleteNonExistentTodoThrowsError() async {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        let nonExistentId = UUID()

        await #expect(throws: ToDoRepositoryError.notFound) {
            try await sut.delete(nonExistentId)
        }
    }

    @MainActor
    @Test("Toggle completion changes todo state")
    func toggleCompletionChangesTodState() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        let todo = try await sut.create(title: "Task", notes: nil)

        var todos = try await sut.fetchAll()
        #expect(todos.first?.isCompleted == false)

        try await sut.toggleCompletion(todo.id)

        todos = try await sut.fetchAll()
        #expect(todos.first?.isCompleted == true)
        #expect(todos.first?.completedAt != nil)
    }

    @MainActor
    @Test("Toggle completion twice returns to original state")
    func toggleCompletionTwiceReturnsToOriginalState() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        let todo = try await sut.create(title: "Task", notes: nil)

        try await sut.toggleCompletion(todo.id)
        try await sut.toggleCompletion(todo.id)

        let todos = try await sut.fetchAll()
        #expect(todos.first?.isCompleted == false)
        #expect(todos.first?.completedAt == nil)
    }

    @MainActor
    @Test("Toggle completion on non-existent todo throws error")
    func toggleCompletionOnNonExistentTodoThrowsError() async {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        let nonExistentId = UUID()

        await #expect(throws: ToDoRepositoryError.notFound) {
            try await sut.toggleCompletion(nonExistentId)
        }
    }
}
