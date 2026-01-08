import Foundation
import SwiftData

protocol ToDoRepositoryProtocol {
    func fetchAll() async throws -> [ToDoEntity]
    func create(title: String, notes: String?) async throws -> ToDoEntity
    func update(_ todo: ToDoEntity) async throws
    func delete(_ id: UUID) async throws
    func toggleCompletion(_ id: UUID) async throws
}

final class ToDoRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
}

extension ToDoRepository: ToDoRepositoryProtocol {
    func fetchAll() async throws -> [ToDoEntity] {
        let descriptor = FetchDescriptor<ToDoModel>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        let models = try modelContext.fetch(descriptor)
        return models.map { $0.toEntity() }
    }

    func create(title: String, notes: String?) async throws -> ToDoEntity {
        let model = ToDoModel(title: title, notes: notes)
        modelContext.insert(model)
        try modelContext.save()
        return model.toEntity()
    }

    func update(_ todo: ToDoEntity) async throws {
        let todoID = todo.id
        let descriptor = FetchDescriptor<ToDoModel>(
            predicate: #Predicate { $0.id == todoID }
        )
        guard let model = try modelContext.fetch(descriptor).first else {
            throw ToDoRepositoryError.notFound
        }

        model.title = todo.title
        model.notes = todo.notes
        model.isCompleted = todo.isCompleted
        model.completedAt = todo.completedAt

        try modelContext.save()
    }

    func delete(_ id: UUID) async throws {
        let descriptor = FetchDescriptor<ToDoModel>(
            predicate: #Predicate { $0.id == id }
        )
        guard let model = try modelContext.fetch(descriptor).first else {
            throw ToDoRepositoryError.notFound
        }

        modelContext.delete(model)
        try modelContext.save()
    }

    func toggleCompletion(_ id: UUID) async throws {
        let descriptor = FetchDescriptor<ToDoModel>(
            predicate: #Predicate { $0.id == id }
        )
        guard let model = try modelContext.fetch(descriptor).first else {
            throw ToDoRepositoryError.notFound
        }

        model.isCompleted.toggle()
        model.completedAt = model.isCompleted ? Date() : nil

        try modelContext.save()
    }
}

enum ToDoRepositoryError: Error {
    case notFound
}
