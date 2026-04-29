// ── FILE: Packages/Presentation/Tests/PresentationTests/ToDoViewModelTests.swift ──

import Testing
import Foundation
import Domain
@testable import Presentation

@Suite("ToDoViewModel")
struct ToDoViewModelTests {

    @Test("Initial state is idle")
    func initialStateIsIdle() {
        let sut = ToDoViewModel(useCase: MockToDoUseCase())
        if case .idle = sut.state { } else {
            Issue.record("Expected idle state")
        }
    }

    @Test("Load todos sets loaded state on success")
    func loadTodosSuccess() async throws {
        let todos = [
            ToDoEntity(title: "Task 1"),
            ToDoEntity(title: "Task 2", isCompleted: true)
        ]
        let useCase = MockToDoUseCase()
        useCase.fetchAllResult = .success(todos)
        let sut = ToDoViewModel(useCase: useCase)

        await sut.loadTodos()

        #expect(sut.todos.count == 2)
        #expect(sut.errorMessage == nil)
    }

    @Test("Load todos sets error state on failure")
    func loadTodosFailure() async {
        let useCase = MockToDoUseCase()
        useCase.fetchAllResult = .failure(TestError.stub)
        let sut = ToDoViewModel(useCase: useCase)

        await sut.loadTodos()

        #expect(sut.errorMessage != nil)
        #expect(sut.todos.isEmpty)
    }

    @Test("Create todo inserts at front of list")
    func createTodoInsertsAtFront() async {
        let useCase = MockToDoUseCase()
        useCase.fetchAllResult = .success([])
        let sut = ToDoViewModel(useCase: useCase)
        await sut.loadTodos()

        await sut.createTodo(title: "New Task", notes: "Note")

        #expect(sut.todos.count == 1)
        #expect(sut.todos.first?.title == "New Task")
    }

    @Test("Delete todo removes from list")
    func deleteTodoRemovesFromList() async {
        let t1 = ToDoEntity(title: "Task 1")
        let t2 = ToDoEntity(title: "Task 2")
        let useCase = MockToDoUseCase()
        useCase.fetchAllResult = .success([t1, t2])
        let sut = ToDoViewModel(useCase: useCase)
        await sut.loadTodos()

        await sut.deleteTodo(t1.id)

        #expect(sut.todos.count == 1)
        #expect(sut.todos.first?.id == t2.id)
    }

    @Test("Toggle completion updates todo")
    func toggleCompletionUpdatesTodo() async {
        let todo = ToDoEntity(title: "Task", isCompleted: false)
        let useCase = MockToDoUseCase()
        useCase.fetchAllResult = .success([todo])
        let sut = ToDoViewModel(useCase: useCase)
        await sut.loadTodos()

        await sut.toggleCompletion(todo.id)

        #expect(sut.todos.first?.isCompleted == true)
        #expect(sut.todos.first?.completedAt != nil)
    }

    @Test("Active todos filters correctly")
    func activeTodosFilter() async {
        let todos = [
            ToDoEntity(title: "Active 1", isCompleted: false),
            ToDoEntity(title: "Done", isCompleted: true),
            ToDoEntity(title: "Active 2", isCompleted: false)
        ]
        let useCase = MockToDoUseCase()
        useCase.fetchAllResult = .success(todos)
        let sut = ToDoViewModel(useCase: useCase)
        await sut.loadTodos()

        #expect(sut.activeTodos.count == 2)
        #expect(sut.completedTodos.count == 1)
    }

    @Test("Update todo modifies existing entry")
    func updateTodoModifiesEntry() async {
        var todo = ToDoEntity(title: "Original")
        let useCase = MockToDoUseCase()
        useCase.fetchAllResult = .success([todo])
        let sut = ToDoViewModel(useCase: useCase)
        await sut.loadTodos()

        todo.title = "Updated"
        await sut.updateTodo(todo)

        #expect(sut.todos.first?.title == "Updated")
    }

    @Test("Preserves list data after delete failure")
    func preservesDataAfterDeleteFailure() async {
        let todo = ToDoEntity(title: "Task")
        let useCase = MockToDoUseCase()
        useCase.fetchAllResult = .success([todo])
        useCase.deleteError = TestError.stub
        let sut = ToDoViewModel(useCase: useCase)
        await sut.loadTodos()

        await sut.deleteTodo(todo.id)

        #expect(sut.errorMessage != nil)
        #expect(sut.todos.count == 1)
    }
}

private enum TestError: Error {
    case stub
}
