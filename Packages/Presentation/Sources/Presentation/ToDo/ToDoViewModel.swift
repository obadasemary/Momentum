import Foundation
import Domain

@Observable
public final class ToDoViewModel {
    public enum State {
        case idle
        case loading
        case loaded([ToDo])
        case empty
        case error(Error, preservedData: [ToDo]?)
    }

    public private(set) var state: State = .idle
    private let useCase: any ToDoUseCaseProtocol

    public var todos: [ToDo] {
        switch state {
        case .loaded(let items): return items
        case .error(_, let items): return items ?? []
        default: return []
        }
    }

    public var activeTodos: [ToDo] { todos.filter { !$0.isCompleted } }
    public var completedTodos: [ToDo] { todos.filter { $0.isCompleted } }

    public var isLoading: Bool {
        if case .loading = state { return true }
        return false
    }

    public var errorMessage: String? {
        if case .error(let error, _) = state { return error.localizedDescription }
        return nil
    }

    public init(useCase: any ToDoUseCaseProtocol) {
        self.useCase = useCase
    }

    public func load() async {
        state = .loading
        do {
            let items = try await useCase.fetchAll()
            state = items.isEmpty ? .empty : .loaded(items)
        } catch {
            state = .error(error, preservedData: nil)
        }
    }

    public func addToDo(title: String, notes: String?) async {
        do {
            try await useCase.addToDo(title: title, notes: notes)
            await load()
        } catch {
            state = .error(error, preservedData: todos.isEmpty ? nil : todos)
        }
    }

    public func toggleCompletion(_ toDo: ToDo) async {
        do {
            try await useCase.toggleCompletion(toDo)
            await load()
        } catch {
            state = .error(error, preservedData: todos.isEmpty ? nil : todos)
        }
    }

    public func deleteToDo(_ toDo: ToDo) async {
        do {
            try await useCase.deleteToDo(toDo)
            await load()
        } catch {
            state = .error(error, preservedData: todos.isEmpty ? nil : todos)
        }
    }

    public func refresh() async {
        await load()
    }
}
