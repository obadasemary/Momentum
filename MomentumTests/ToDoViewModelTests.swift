import Testing
@testable import Momentum

struct ToDoViewModelTests {

    @MainActor
    @Test("Test Load Todos With Success")
    func loadTodosWithSuccess() async throws {
        let mockTodos = [
            ToDoEntity(title: "Task 1", notes: "Note 1"),
            ToDoEntity(title: "Task 2", notes: nil, isCompleted: true)
        ]

        let mockUseCase = MockToDoUseCase()
        mockUseCase.fetchAllResult = .success(mockTodos)

        let sut = ToDoViewModel(useCase: mockUseCase)

        await sut.loadTodos()

        #expect(sut.todos == mockTodos)
        #expect(sut.todos.count == 2)
    }

    @MainActor
    @Test("Test Load Todos With Failure")
    func loadTodosWithFailure() async throws {
        let mockUseCase = MockToDoUseCase()
        mockUseCase.fetchAllResult = .failure(MockError.stub)

        let sut = ToDoViewModel(useCase: mockUseCase)

        await sut.loadTodos()

        #expect(sut.todos.isEmpty)
        #expect(sut.errorMessage != nil)
    }

    @MainActor
    @Test("Initial state is idle")
    func initialStateIsIdle() {
        let mockUseCase = MockToDoUseCase()
        let sut = ToDoViewModel(useCase: mockUseCase)

        if case .idle = sut.state {
            // Success
        } else {
            Issue.record("Expected idle state")
        }
    }

    @MainActor
    @Test("Loading state is set correctly")
    func loadingStateIsSetCorrectly() async {
        let mockUseCase = MockToDoUseCase()
        mockUseCase.fetchAllResult = .success([])

        let sut = ToDoViewModel(useCase: mockUseCase)

        #expect(sut.isLoading == false)

        let loadTask = Task { await sut.loadTodos() }
        await loadTask.value

        #expect(sut.isLoading == false)
    }

    @MainActor
    @Test("Create Todo adds to list")
    func createTodoAddsToList() async {
        let mockUseCase = MockToDoUseCase()
        mockUseCase.fetchAllResult = .success([])

        let sut = ToDoViewModel(useCase: mockUseCase)
        await sut.loadTodos()

        #expect(sut.todos.isEmpty)

        await sut.createTodo(title: "New Task", notes: "New Note")

        #expect(sut.todos.count == 1)
        #expect(sut.todos.first?.title == "New Task")
        #expect(sut.todos.first?.notes == "New Note")
    }

    @MainActor
    @Test("Delete Todo removes from list")
    func deleteTodoRemovesFromList() async {
        let todo1 = ToDoEntity(title: "Task 1")
        let todo2 = ToDoEntity(title: "Task 2")

        let mockUseCase = MockToDoUseCase()
        mockUseCase.fetchAllResult = .success([todo1, todo2])

        let sut = ToDoViewModel(useCase: mockUseCase)
        await sut.loadTodos()

        #expect(sut.todos.count == 2)

        await sut.deleteTodo(todo1.id)

        #expect(sut.todos.count == 1)
        #expect(sut.todos.first?.id == todo2.id)
    }

    @MainActor
    @Test("Toggle Completion updates todo state")
    func toggleCompletionUpdatesTodoState() async {
        let todo = ToDoEntity(title: "Task 1", isCompleted: false)

        let mockUseCase = MockToDoUseCase()
        mockUseCase.fetchAllResult = .success([todo])

        let sut = ToDoViewModel(useCase: mockUseCase)
        await sut.loadTodos()

        #expect(sut.todos.first?.isCompleted == false)

        await sut.toggleCompletion(todo.id)

        #expect(sut.todos.first?.isCompleted == true)
        #expect(sut.todos.first?.completedAt != nil)
    }

    @MainActor
    @Test("Active Todos filters correctly")
    func activeTodosFiltersCorrectly() async {
        let mockTodos = [
            ToDoEntity(title: "Active 1", isCompleted: false),
            ToDoEntity(title: "Completed 1", isCompleted: true),
            ToDoEntity(title: "Active 2", isCompleted: false)
        ]

        let mockUseCase = MockToDoUseCase()
        mockUseCase.fetchAllResult = .success(mockTodos)

        let sut = ToDoViewModel(useCase: mockUseCase)
        await sut.loadTodos()

        #expect(sut.activeTodos.count == 2)
        #expect(sut.activeTodos.allSatisfy { !$0.isCompleted })
    }

    @MainActor
    @Test("Completed Todos filters correctly")
    func completedTodosFiltersCorrectly() async {
        let mockTodos = [
            ToDoEntity(title: "Active 1", isCompleted: false),
            ToDoEntity(title: "Completed 1", isCompleted: true),
            ToDoEntity(title: "Active 2", isCompleted: false)
        ]

        let mockUseCase = MockToDoUseCase()
        mockUseCase.fetchAllResult = .success(mockTodos)

        let sut = ToDoViewModel(useCase: mockUseCase)
        await sut.loadTodos()

        #expect(sut.completedTodos.count == 1)
        #expect(sut.completedTodos.allSatisfy { $0.isCompleted })
    }

    @MainActor
    @Test("Update Todo modifies existing todo")
    func updateTodoModifiesExistingTodo() async {
        var todo = ToDoEntity(title: "Original Title", notes: "Original Notes")

        let mockUseCase = MockToDoUseCase()
        mockUseCase.fetchAllResult = .success([todo])

        let sut = ToDoViewModel(useCase: mockUseCase)
        await sut.loadTodos()

        todo.title = "Updated Title"
        todo.notes = "Updated Notes"

        await sut.updateTodo(todo)

        #expect(sut.todos.first?.title == "Updated Title")
        #expect(sut.todos.first?.notes == "Updated Notes")
    }

    @MainActor
    @Test("Error state contains error message")
    func errorStateContainsErrorMessage() async {
        let mockUseCase = MockToDoUseCase()
        mockUseCase.fetchAllResult = .failure(MockError.stub)

        let sut = ToDoViewModel(useCase: mockUseCase)
        await sut.loadTodos()

        #expect(sut.errorMessage != nil)
    }
}

private extension ToDoViewModelTests {
    enum MockError: Error {
        case stub
    }
}
