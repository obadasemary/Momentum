import Testing
import Foundation
@testable import Presentation
import Domain

@MainActor
@Suite("ToDoViewModel")
struct ToDoViewModelTests {
    private func makeToDo(id: UUID = UUID(), title: String = "Test", isCompleted: Bool = false) -> ToDo {
        ToDo(id: id, title: title, notes: nil, isCompleted: isCompleted, createdAt: Date(), completedAt: nil)
    }

    @Test("Initial state is idle")
    func initialStateIsIdle() {
        let mock = MockToDoUseCase()
        let vm = ToDoViewModel(useCase: mock)
        if case .idle = vm.state {} else {
            Issue.record("Expected idle state")
        }
    }

    @Test("load() transitions to loaded when items exist")
    func loadTransitionsToLoaded() async {
        let mock = MockToDoUseCase()
        mock.fetchAllResult = .success([makeToDo()])
        let vm = ToDoViewModel(useCase: mock)

        await vm.load()

        #expect(vm.todos.count == 1)
        if case .loaded = vm.state {} else {
            Issue.record("Expected loaded state")
        }
    }

    @Test("load() transitions to empty when no items")
    func loadTransitionsToEmpty() async {
        let mock = MockToDoUseCase()
        mock.fetchAllResult = .success([])
        let vm = ToDoViewModel(useCase: mock)

        await vm.load()

        if case .empty = vm.state {} else {
            Issue.record("Expected empty state")
        }
    }

    @Test("load() transitions to error on failure")
    func loadTransitionsToError() async {
        let mock = MockToDoUseCase()
        mock.fetchAllResult = .failure(URLError(.unknown))
        let vm = ToDoViewModel(useCase: mock)

        await vm.load()

        #expect(vm.errorMessage != nil)
    }

    @Test("addToDo() reloads after adding")
    func addToDoReloads() async {
        let mock = MockToDoUseCase()
        mock.fetchAllResult = .success([makeToDo(title: "Buy milk")])
        let vm = ToDoViewModel(useCase: mock)

        await vm.addToDo(title: "Buy milk", notes: nil)

        #expect(vm.todos.count == 1)
    }

    @Test("toggleCompletion() reloads after toggling")
    func toggleCompletionReloads() async {
        let mock = MockToDoUseCase()
        let toDo = makeToDo(title: "Test task")
        mock.fetchAllResult = .success([makeToDo(title: "Test task", isCompleted: true)])
        let vm = ToDoViewModel(useCase: mock)

        await vm.toggleCompletion(toDo)

        #expect(vm.completedTodos.count == 1)
    }

    @Test("deleteToDo() reloads after deletion")
    func deleteToDoReloads() async {
        let mock = MockToDoUseCase()
        mock.fetchAllResult = .success([])
        let vm = ToDoViewModel(useCase: mock)
        let toDo = makeToDo()

        await vm.deleteToDo(toDo)

        #expect(vm.todos.isEmpty)
    }

    @Test("activeTodos only returns incomplete items")
    func activeTodosFilter() async {
        let mock = MockToDoUseCase()
        mock.fetchAllResult = .success([
            makeToDo(title: "Active"),
            makeToDo(title: "Done", isCompleted: true)
        ])
        let vm = ToDoViewModel(useCase: mock)
        await vm.load()

        #expect(vm.activeTodos.count == 1)
        #expect(vm.activeTodos.first?.title == "Active")
    }

    @Test("completedTodos only returns completed items")
    func completedTodosFilter() async {
        let mock = MockToDoUseCase()
        mock.fetchAllResult = .success([
            makeToDo(title: "Active"),
            makeToDo(title: "Done", isCompleted: true)
        ])
        let vm = ToDoViewModel(useCase: mock)
        await vm.load()

        #expect(vm.completedTodos.count == 1)
        #expect(vm.completedTodos.first?.title == "Done")
    }

    @Test("addToDo() error transitions to error state with preserved data")
    func addToDoErrorPreservesData() async {
        let mock = MockToDoUseCase()
        mock.fetchAllResult = .success([makeToDo(title: "Existing")])
        let vm = ToDoViewModel(useCase: mock)
        await vm.load()

        mock.addError = URLError(.unknown)
        mock.fetchAllResult = .success([makeToDo(title: "Existing")])
        await vm.addToDo(title: "New task", notes: nil)

        #expect(vm.errorMessage != nil)
    }

    @Test("refresh() reloads state")
    func refreshReloads() async {
        let mock = MockToDoUseCase()
        mock.fetchAllResult = .success([makeToDo(title: "First")])
        let vm = ToDoViewModel(useCase: mock)
        await vm.load()

        mock.fetchAllResult = .success([makeToDo(title: "Second")])
        await vm.refresh()

        #expect(vm.todos.first?.title == "Second")
    }

    @Test("isLoading is false after load completes")
    func isLoadingFalseAfterLoad() async {
        let mock = MockToDoUseCase()
        mock.fetchAllResult = .success([makeToDo()])
        let vm = ToDoViewModel(useCase: mock)
        await vm.load()

        #expect(!vm.isLoading)
    }
}
