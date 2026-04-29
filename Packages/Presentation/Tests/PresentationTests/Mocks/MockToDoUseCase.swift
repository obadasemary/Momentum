// ── FILE: Packages/Presentation/Tests/PresentationTests/Mocks/MockToDoUseCase.swift ──

import Foundation
import Domain
@testable import Presentation

final class MockToDoUseCase: ToDoUseCaseProtocol {

    var fetchAllResult: Result<[ToDoEntity], Error> = .success([])
    var createResult: Result<ToDoEntity, Error>?
    var updateError: Error?
    var deleteError: Error?
    var toggleError: Error?

    func fetchAll() async throws -> [ToDoEntity] {
        try fetchAllResult.get()
    }

    func create(title: String, notes: String?) async throws -> ToDoEntity {
        if let result = createResult { return try result.get() }
        return ToDoEntity(title: title, notes: notes)
    }

    func update(_ todo: ToDoEntity) async throws {
        if let error = updateError { throw error }
    }

    func delete(_ id: UUID) async throws {
        if let error = deleteError { throw error }
    }

    func toggleCompletion(_ id: UUID) async throws {
        if let error = toggleError { throw error }
    }
}
