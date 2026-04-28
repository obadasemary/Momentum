import Testing
import Foundation
@testable import Domain

@Suite("ToDoUseCase Edge Cases")
struct ToDoEdgeCasesTests {

    @Test("Create with very long title succeeds")
    func longTitle() async throws {
        let sut = ToDoUseCase(repository: MockToDoRepository())
        let longTitle = String(repeating: "a", count: 1000)
        let todo = try await sut.create(title: longTitle, notes: nil)
        #expect(todo.title.count == 1000)
    }

    @Test("Create with special characters succeeds")
    func specialCharacters() async throws {
        let sut = ToDoUseCase(repository: MockToDoRepository())
        let title = "Task 123 !@#$%^&*()_+-=[]{}|;':\",./<>?"
        let todo = try await sut.create(title: title, notes: nil)
        #expect(todo.title == title)
    }

    @Test("Create with emoji in title succeeds")
    func emojiTitle() async throws {
        let sut = ToDoUseCase(repository: MockToDoRepository())
        let todo = try await sut.create(title: "Buy groceries 🛒", notes: nil)
        #expect(todo.title == "Buy groceries 🛒")
    }

    @Test("Created date is within expected range")
    func createdDateInRange() async throws {
        let sut = ToDoUseCase(repository: MockToDoRepository())
        let before = Date()
        let todo = try await sut.create(title: "Task", notes: nil)
        let after = Date()
        #expect(todo.createdAt >= before)
        #expect(todo.createdAt <= after)
    }

    @Test("Completion date is set when toggled to complete")
    func completionDateSetOnToggle() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)
        let todo = try await sut.create(title: "Task", notes: nil)

        let before = Date()
        try await sut.toggleCompletion(todo.id)
        let after = Date()

        let todos = try await sut.fetchAll()
        #expect(todos.first?.completedAt != nil)
        #expect(todos.first!.completedAt! >= before)
        #expect(todos.first!.completedAt! <= after)
    }

    @Test("Completion date is cleared when toggled back")
    func completionDateClearedOnToggleBack() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)
        let todo = try await sut.create(title: "Task", notes: nil)
        try await sut.toggleCompletion(todo.id)
        try await sut.toggleCompletion(todo.id)

        let todos = try await sut.fetchAll()
        #expect(todos.first?.completedAt == nil)
    }

    @Test("Update notes to nil succeeds")
    func updateNotesToNil() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)
        var todo = try await sut.create(title: "Task", notes: "Original")
        todo.notes = nil
        try await sut.update(todo)
        let todos = try await sut.fetchAll()
        #expect(todos.first?.notes == nil)
    }

    @Test("Multiple operations maintain consistency")
    func multipleOperationsConsistency() async throws {
        let repository = MockToDoRepository()
        let sut = ToDoUseCase(repository: repository)
        let todo1 = try await sut.create(title: "Task 1", notes: nil)
        let todo2 = try await sut.create(title: "Task 2", notes: "Note 2")
        let todo3 = try await sut.create(title: "Task 3", notes: nil)

        try await sut.toggleCompletion(todo2.id)
        try await sut.delete(todo3.id)
        var updated = todo1
        updated.title = "Updated Task 1"
        try await sut.update(updated)

        let todos = try await sut.fetchAll()
        #expect(todos.count == 2)
        #expect(todos.contains { $0.id == todo1.id && $0.title == "Updated Task 1" })
        #expect(todos.contains { $0.id == todo2.id && $0.isCompleted == true })
        #expect(!todos.contains { $0.id == todo3.id })
    }
}
