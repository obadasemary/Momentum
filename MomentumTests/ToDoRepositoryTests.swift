import Testing
import Foundation
@testable import Momentum

struct ToDoRepositoryTests {

    @MainActor
    @Test("Fetch all returns empty array initially")
    func fetchAllReturnsEmptyArrayInitially() async throws {
        let sut = MockToDoRepository()

        let todos = try await sut.fetchAll()

        #expect(todos.isEmpty)
    }

    @MainActor
    @Test("Create todo adds to repository")
    func createTodoAddsToRepository() async throws {
        let sut = MockToDoRepository()

        let todo = try await sut.create(title: "Task 1", notes: "Note 1")

        #expect(todo.title == "Task 1")
        #expect(todo.notes == "Note 1")
        #expect(todo.isCompleted == false)

        let todos = try await sut.fetchAll()
        #expect(todos.count == 1)
        #expect(todos.first?.id == todo.id)
    }

    @MainActor
    @Test("Create multiple todos maintains order by creation date")
    func createMultipleTodosMaintainsOrder() async throws {
        let sut = MockToDoRepository()

        let todo1 = try await sut.create(title: "First", notes: nil)
        let todo2 = try await sut.create(title: "Second", notes: nil)
        let todo3 = try await sut.create(title: "Third", notes: nil)

        let todos = try await sut.fetchAll()

        #expect(todos.count == 3)
        #expect(todos[0].id == todo3.id)
        #expect(todos[1].id == todo2.id)
        #expect(todos[2].id == todo1.id)
    }

    @MainActor
    @Test("Update todo modifies existing todo")
    func updateTodoModifiesExisting() async throws {
        let sut = MockToDoRepository()

        var todo = try await sut.create(title: "Original", notes: "Original Note")
        todo.title = "Updated"
        todo.notes = "Updated Note"
        todo.isCompleted = true

        try await sut.update(todo)

        let todos = try await sut.fetchAll()
        #expect(todos.first?.title == "Updated")
        #expect(todos.first?.notes == "Updated Note")
        #expect(todos.first?.isCompleted == true)
    }

    @MainActor
    @Test("Update non-existent todo throws notFound error")
    func updateNonExistentTodoThrowsError() async {
        let sut = MockToDoRepository()

        let nonExistentTodo = ToDoEntity(title: "Non-existent")

        await #expect(throws: ToDoRepositoryError.notFound) {
            try await sut.update(nonExistentTodo)
        }
    }

    @MainActor
    @Test("Delete todo removes from repository")
    func deleteTodoRemovesFromRepository() async throws {
        let sut = MockToDoRepository()

        let todo1 = try await sut.create(title: "Task 1", notes: nil)
        let todo2 = try await sut.create(title: "Task 2", notes: nil)

        var todos = try await sut.fetchAll()
        #expect(todos.count == 2)

        try await sut.delete(todo1.id)

        todos = try await sut.fetchAll()
        #expect(todos.count == 1)
        #expect(todos.first?.id == todo2.id)
    }

    @MainActor
    @Test("Delete non-existent todo throws notFound error")
    func deleteNonExistentTodoThrowsError() async {
        let sut = MockToDoRepository()

        let nonExistentId = UUID()

        await #expect(throws: ToDoRepositoryError.notFound) {
            try await sut.delete(nonExistentId)
        }
    }

    @MainActor
    @Test("Toggle completion marks todo as completed")
    func toggleCompletionMarksAsCompleted() async throws {
        let sut = MockToDoRepository()

        let todo = try await sut.create(title: "Task", notes: nil)

        try await sut.toggleCompletion(todo.id)

        let todos = try await sut.fetchAll()
        #expect(todos.first?.isCompleted == true)
        #expect(todos.first?.completedAt != nil)
    }

    @MainActor
    @Test("Toggle completion twice returns to incomplete state")
    func toggleCompletionTwiceReturnsToIncomplete() async throws {
        let sut = MockToDoRepository()

        let todo = try await sut.create(title: "Task", notes: nil)

        try await sut.toggleCompletion(todo.id)
        try await sut.toggleCompletion(todo.id)

        let todos = try await sut.fetchAll()
        #expect(todos.first?.isCompleted == false)
        #expect(todos.first?.completedAt == nil)
    }

    @MainActor
    @Test("Toggle completion on non-existent todo throws notFound error")
    func toggleCompletionNonExistentThrowsError() async {
        let sut = MockToDoRepository()

        let nonExistentId = UUID()

        await #expect(throws: ToDoRepositoryError.notFound) {
            try await sut.toggleCompletion(nonExistentId)
        }
    }

    @MainActor
    @Test("Create todo with nil notes stores nil")
    func createTodoWithNilNotesStoresNil() async throws {
        let sut = MockToDoRepository()

        let todo = try await sut.create(title: "Task", notes: nil)

        #expect(todo.notes == nil)

        let todos = try await sut.fetchAll()
        #expect(todos.first?.notes == nil)
    }

    @MainActor
    @Test("Create todo with empty notes stores empty string")
    func createTodoWithEmptyNotesStoresEmptyString() async throws {
        let sut = MockToDoRepository()

        let todo = try await sut.create(title: "Task", notes: "")

        #expect(todo.notes == "")

        let todos = try await sut.fetchAll()
        #expect(todos.first?.notes == "")
    }

    @MainActor
    @Test("Multiple operations maintain data consistency")
    func multipleOperationsMaintainConsistency() async throws {
        let sut = MockToDoRepository()

        let todo1 = try await sut.create(title: "Task 1", notes: nil)
        let todo2 = try await sut.create(title: "Task 2", notes: "Note 2")
        let todo3 = try await sut.create(title: "Task 3", notes: nil)

        try await sut.toggleCompletion(todo2.id)
        try await sut.delete(todo3.id)

        var todo1Updated = todo1
        todo1Updated.title = "Updated Task 1"
        try await sut.update(todo1Updated)

        let todos = try await sut.fetchAll()

        #expect(todos.count == 2)
        #expect(todos.contains { $0.id == todo1.id && $0.title == "Updated Task 1" })
        #expect(todos.contains { $0.id == todo2.id && $0.isCompleted == true })
        #expect(!todos.contains { $0.id == todo3.id })
    }
}
