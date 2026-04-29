// ── FILE: Packages/Presentation/Sources/Presentation/Features/ToDo/ViewModels/ToDoViewModel.swift ──

import Foundation
import Observation
import Domain

@Observable
public final class ToDoViewModel {

    public enum State {
        case idle
        case loading
        case loaded([ToDoEntity])
        case error(Error, preservedData: [ToDoEntity]?)
    }

    public private(set) var state: State = .idle
    private let useCase: ToDoUseCaseProtocol

    public var todos: [ToDoEntity] {
        switch state {
        case .loaded(let todos): return todos
        case .error(_, let data): return data ?? []
        default: return []
        }
    }

    public var isLoading: Bool {
        if case .loading = state { return true }
        return false
    }

    public var errorMessage: String? {
        if case .error(let error, _) = state { return error.localizedDescription }
        return nil
    }

    public var activeTodos: [ToDoEntity] { todos.filter { !$0.isCompleted } }
    public var completedTodos: [ToDoEntity] { todos.filter { $0.isCompleted } }

    public init(useCase: ToDoUseCaseProtocol) {
        self.useCase = useCase
    }

    public func loadTodos() async {
        state = .loading
        do {
            let todos = try await useCase.fetchAll()
            state = .loaded(todos)
        } catch {
            state = .error(error, preservedData: nil)
        }
    }

    public func createTodo(title: String, notes: String?) async {
        guard case .loaded(let current) = state else { return }
        do {
            let new = try await useCase.create(title: title, notes: notes)
            state = .loaded([new] + current)
        } catch {
            state = .error(error, preservedData: current)
        }
    }

    public func updateTodo(_ todo: ToDoEntity) async {
        guard case .loaded(var current) = state else { return }
        do {
            try await useCase.update(todo)
            if let i = current.firstIndex(where: { $0.id == todo.id }) {
                current[i] = todo
                state = .loaded(current)
            }
        } catch {
            state = .error(error, preservedData: current)
        }
    }

    public func deleteTodo(_ id: UUID) async {
        guard case .loaded(var current) = state else { return }
        do {
            try await useCase.delete(id)
            current.removeAll { $0.id == id }
            state = .loaded(current)
        } catch {
            state = .error(error, preservedData: current)
        }
    }

    public func toggleCompletion(_ id: UUID) async {
        guard case .loaded(var current) = state else { return }
        do {
            try await useCase.toggleCompletion(id)
            if let i = current.firstIndex(where: { $0.id == id }) {
                current[i].isCompleted.toggle()
                current[i].completedAt = current[i].isCompleted ? Date() : nil
                state = .loaded(current)
            }
        } catch {
            state = .error(error, preservedData: current)
        }
    }
}
