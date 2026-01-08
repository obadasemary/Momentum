import Foundation

@Observable
final class ToDoViewModel {
    enum State {
        case idle
        case loading
        case loaded([ToDoEntity])
        case error(Error, preservedData: [ToDoEntity]?)
    }

    private(set) var state: State = .idle
    private let useCase: ToDoUseCaseProtocol

    var todos: [ToDoEntity] {
        switch state {
        case .loaded(let todos):
            return todos
        case .error(_, let preservedData):
            return preservedData ?? []
        default:
            return []
        }
    }

    var isLoading: Bool {
        if case .loading = state {
            return true
        }
        return false
    }

    var errorMessage: String? {
        if case .error(let error, _) = state {
            return error.localizedDescription
        }
        return nil
    }

    var activeTodos: [ToDoEntity] {
        todos.filter { !$0.isCompleted }
    }

    var completedTodos: [ToDoEntity] {
        todos.filter { $0.isCompleted }
    }

    init(useCase: ToDoUseCaseProtocol) {
        self.useCase = useCase
    }

    func loadTodos() async {
        state = .loading

        do {
            let todos = try await useCase.fetchAll()
            state = .loaded(todos)
        } catch {
            state = .error(error, preservedData: nil)
        }
    }

    func createTodo(title: String, notes: String?) async {
        guard case .loaded(let currentTodos) = state else { return }

        do {
            let newTodo = try await useCase.create(title: title, notes: notes)
            var todos = currentTodos
            todos.insert(newTodo, at: 0)
            state = .loaded(todos)
        } catch {
            state = .error(error, preservedData: currentTodos)
        }
    }

    func updateTodo(_ todo: ToDoEntity) async {
        guard case .loaded(let currentTodos) = state else { return }

        do {
            try await useCase.update(todo)
            var todos = currentTodos
            if let index = todos.firstIndex(where: { $0.id == todo.id }) {
                todos[index] = todo
                state = .loaded(todos)
            }
        } catch {
            state = .error(error, preservedData: currentTodos)
        }
    }

    func deleteTodo(_ id: UUID) async {
        guard case .loaded(let currentTodos) = state else { return }

        do {
            try await useCase.delete(id)
            var todos = currentTodos
            todos.removeAll { $0.id == id }
            state = .loaded(todos)
        } catch {
            state = .error(error, preservedData: currentTodos)
        }
    }

    func toggleCompletion(_ id: UUID) async {
        guard case .loaded(let currentTodos) = state else { return }

        do {
            try await useCase.toggleCompletion(id)
            var todos = currentTodos
            if let index = todos.firstIndex(where: { $0.id == id }) {
                todos[index].isCompleted.toggle()
                todos[index].completedAt = todos[index].isCompleted ? Date() : nil
                state = .loaded(todos)
            }
        } catch {
            state = .error(error, preservedData: currentTodos)
        }
    }
}
