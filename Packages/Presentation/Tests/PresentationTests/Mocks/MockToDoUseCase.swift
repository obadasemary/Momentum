import Foundation
import Domain

final class MockToDoUseCase: ToDoUseCaseProtocol, @unchecked Sendable {
    var fetchAllResult: Result<[ToDo], Error> = .success([])
    var addError: Error?
    var toggleError: Error?
    var deleteError: Error?

    func fetchAll() async throws -> [ToDo] {
        switch fetchAllResult {
        case .success(let items): return items
        case .failure(let error): throw error
        }
    }

    func addToDo(title: String, notes: String?) async throws {
        if let error = addError { throw error }
    }

    func toggleCompletion(_ toDo: ToDo) async throws {
        if let error = toggleError { throw error }
    }

    func deleteToDo(_ toDo: ToDo) async throws {
        if let error = deleteError { throw error }
    }
}
