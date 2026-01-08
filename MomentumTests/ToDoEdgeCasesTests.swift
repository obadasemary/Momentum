import Testing
import Foundation
@testable import Momentum

struct ToDoEdgeCasesTests {

    // MARK: - Title Edge Cases

    @MainActor
    @Test("Create todo with very long title succeeds")
    func createTodoWithVeryLongTitle() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        let longTitle = String(repeating: "a", count: 1000)
        let todo = try await sut.create(title: longTitle, notes: nil)

        #expect(todo.title.count == 1000)
    }

    @MainActor
    @Test("Create todo with special characters in title succeeds")
    func createTodoWithSpecialCharacters() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        let specialTitle = "Task 123 !@#$%^&*()_+-=[]{}|;':\",./<>?"
        let todo = try await sut.create(title: specialTitle, notes: nil)

        #expect(todo.title == specialTitle)
    }

    @MainActor
    @Test("Create todo with emoji in title succeeds")
    func createTodoWithEmoji() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        let emojiTitle = "Buy groceries 🛒"
        let todo = try await sut.create(title: emojiTitle, notes: nil)

        #expect(todo.title == emojiTitle)
    }

    @MainActor
    @Test("Create todo with newlines in title succeeds")
    func createTodoWithNewlines() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        let multilineTitle = "Task\nwith\nnewlines"
        let todo = try await sut.create(title: multilineTitle, notes: nil)

        #expect(todo.title == multilineTitle)
    }

    @MainActor
    @Test("Create todo with tabs in title succeeds")
    func createTodoWithTabs() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        let tabTitle = "Task\t\twith\ttabs"
        let todo = try await sut.create(title: tabTitle, notes: nil)

        #expect(todo.title == tabTitle)
    }

    // MARK: - Notes Edge Cases

    @MainActor
    @Test("Create todo with very long notes succeeds")
    func createTodoWithVeryLongNotes() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        let longNotes = String(repeating: "note ", count: 1000)
        let todo = try await sut.create(title: "Task", notes: longNotes)

        #expect(todo.notes?.count == 5000)
    }

    @MainActor
    @Test("Create todo with empty string notes stores empty string")
    func createTodoWithEmptyStringNotes() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        let todo = try await sut.create(title: "Task", notes: "")

        #expect(todo.notes == "")
    }

    @MainActor
    @Test("Update todo notes to nil succeeds")
    func updateTodoNotesToNil() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        var todo = try await sut.create(title: "Task", notes: "Original notes")
        todo.notes = nil

        try await sut.update(todo)

        let todos = try await sut.fetchAll()
        #expect(todos.first?.notes == nil)
    }

    @MainActor
    @Test("Update todo notes to empty string succeeds")
    func updateTodoNotesToEmptyString() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        var todo = try await sut.create(title: "Task", notes: "Original notes")
        todo.notes = ""

        try await sut.update(todo)

        let todos = try await sut.fetchAll()
        #expect(todos.first?.notes == "")
    }

    // MARK: - Date Edge Cases

    @MainActor
    @Test("Todo created date is set correctly")
    func todoCreatedDateIsSetCorrectly() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        let beforeCreation = Date()
        let todo = try await sut.create(title: "Task", notes: nil)
        let afterCreation = Date()

        #expect(todo.createdAt >= beforeCreation)
        #expect(todo.createdAt <= afterCreation)
    }

    @MainActor
    @Test("Completion date is set when toggled to complete")
    func completionDateSetWhenToggled() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        let todo = try await sut.create(title: "Task", notes: nil)

        let beforeToggle = Date()
        try await sut.toggleCompletion(todo.id)
        let afterToggle = Date()

        let todos = try await sut.fetchAll()
        let completedTodo = todos.first

        #expect(completedTodo?.completedAt != nil)
        #expect(completedTodo!.completedAt! >= beforeToggle)
        #expect(completedTodo!.completedAt! <= afterToggle)
    }

    @MainActor
    @Test("Completion date is cleared when toggled back to incomplete")
    func completionDateClearedWhenToggledBack() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        let todo = try await sut.create(title: "Task", notes: nil)

        try await sut.toggleCompletion(todo.id)
        var todos = try await sut.fetchAll()
        #expect(todos.first?.completedAt != nil)

        try await sut.toggleCompletion(todo.id)
        todos = try await sut.fetchAll()
        #expect(todos.first?.completedAt == nil)
    }

    // MARK: - ViewModel Edge Cases

    @MainActor
    @Test("ViewModel handles rapid consecutive operations")
    func viewModelHandlesRapidOperations() async {
        let mockUseCase = MockToDoUseCase()
        mockUseCase.fetchAllResult = .success([])

        let sut = ToDoViewModel(useCase: mockUseCase)
        await sut.loadTodos()

        await sut.createTodo(title: "Task 1", notes: nil)
        await sut.createTodo(title: "Task 2", notes: nil)
        await sut.createTodo(title: "Task 3", notes: nil)

        #expect(sut.todos.count == 3)
    }

    @MainActor
    @Test("ViewModel state after create failure")
    func viewModelStateAfterCreateFailure() async {
        let mockUseCase = MockToDoUseCase()
        mockUseCase.fetchAllResult = .success([])
        mockUseCase.createResult = .failure(TestError.createFailed)

        let sut = ToDoViewModel(useCase: mockUseCase)
        await sut.loadTodos()

        await sut.createTodo(title: "Task", notes: nil)

        #expect(sut.errorMessage != nil)
        #expect(sut.todos.isEmpty)
    }

    @MainActor
    @Test("ViewModel preserves data after delete failure")
    func viewModelPreservesDataAfterDeleteFailure() async {
        let todo = ToDoEntity(title: "Task 1")

        let mockUseCase = MockToDoUseCase()
        mockUseCase.fetchAllResult = .success([todo])
        mockUseCase.deleteError = TestError.deleteFailed

        let sut = ToDoViewModel(useCase: mockUseCase)
        await sut.loadTodos()

        #expect(sut.todos.count == 1)

        await sut.deleteTodo(todo.id)

        #expect(sut.errorMessage != nil)
        #expect(sut.todos.count == 1)
    }

    @MainActor
    @Test("ViewModel handles toggle completion failure")
    func viewModelHandlesToggleFailure() async {
        let todo = ToDoEntity(title: "Task 1", isCompleted: false)

        let mockUseCase = MockToDoUseCase()
        mockUseCase.fetchAllResult = .success([todo])
        mockUseCase.toggleCompletionError = TestError.toggleFailed

        let sut = ToDoViewModel(useCase: mockUseCase)
        await sut.loadTodos()

        #expect(sut.todos.first?.isCompleted == false)

        await sut.toggleCompletion(todo.id)

        #expect(sut.errorMessage != nil)
        #expect(sut.todos.first?.isCompleted == false)
    }

    // MARK: - ID Uniqueness

    @MainActor
    @Test("Created todos have unique IDs")
    func createdTodosHaveUniqueIDs() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)

        let todo1 = try await sut.create(title: "Task 1", notes: nil)
        let todo2 = try await sut.create(title: "Task 2", notes: nil)
        let todo3 = try await sut.create(title: "Task 3", notes: nil)

        #expect(todo1.id != todo2.id)
        #expect(todo2.id != todo3.id)
        #expect(todo1.id != todo3.id)
    }
}

private extension ToDoEdgeCasesTests {
    enum TestError: Error {
        case createFailed
        case deleteFailed
        case toggleFailed
    }
}
