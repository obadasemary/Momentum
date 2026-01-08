import Foundation

@Observable
final class ToDoViewModel {
    enum State {
        case idle
        case loading
        case loaded([ToDoEntity])
        case error(Error)
    }

    private(set) var state: State = .idle
    private let useCase: ToDoUseCaseProtocol

    var todos: [ToDoEntity] {
        if case .loaded(let todos) = state {
            return todos
        }
        return []
    }

    var isLoading: Bool {
        if case .loading = state {
            return true
        }
        return false
    }

    var errorMessage: String? {
        if case .error(let error) = state {
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
            state = .error(error)
        }
    }

    func createTodo(title: String, notes: String?) async {
        do {
            let newTodo = try await useCase.create(title: title, notes: notes)
            if case .loaded(var todos) = state {
                todos.insert(newTodo, at: 0)
                state = .loaded(todos)
            }
        } catch {
            state = .error(error)
        }
    }

    func updateTodo(_ todo: ToDoEntity) async {
        do {
            try await useCase.update(todo)
            if case .loaded(var todos) = state {
                if let index = todos.firstIndex(where: { $0.id == todo.id }) {
                    todos[index] = todo
                    state = .loaded(todos)
                }
            }
        } catch {
            state = .error(error)
        }
    }

    func deleteTodo(_ id: UUID) async {
        do {
            try await useCase.delete(id)
            if case .loaded(var todos) = state {
                todos.removeAll { $0.id == id }
                state = .loaded(todos)
            }
        } catch {
            state = .error(error)
        }
    }

    func toggleCompletion(_ id: UUID) async {
        do {
            try await useCase.toggleCompletion(id)
            if case .loaded(var todos) = state {
                if let index = todos.firstIndex(where: { $0.id == id }) {
                    todos[index].isCompleted.toggle()
                    todos[index].completedAt = todos[index].isCompleted ? Date() : nil
                    state = .loaded(todos)
                }
            }
        } catch {
            state = .error(error)
        }
    }
}
