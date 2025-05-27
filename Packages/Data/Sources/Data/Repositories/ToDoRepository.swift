import Foundation
import SwiftData
import Domain

public enum ToDoRepositoryError: Error, Sendable {
    case notFound
}

public final class ToDoRepository: ToDoRepositoryProtocol {
    private let modelContext: ModelContext

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    public func fetchAll() async throws -> [ToDo] {
        let descriptor = FetchDescriptor<ToDoModel>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        let models = try modelContext.fetch(descriptor)
        return models.map { $0.toDomain() }
    }

    public func create(title: String, notes: String?) async throws -> ToDo {
        let model = ToDoModel(title: title, notes: notes)
        modelContext.insert(model)
        try modelContext.save()
        return model.toDomain()
    }

    public func update(_ todo: ToDo) async throws {
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

    public func delete(_ id: UUID) async throws {
        let descriptor = FetchDescriptor<ToDoModel>(
            predicate: #Predicate { $0.id == id }
        )
        guard let model = try modelContext.fetch(descriptor).first else {
            throw ToDoRepositoryError.notFound
        }
        modelContext.delete(model)
        try modelContext.save()
    }

    public func toggleCompletion(_ id: UUID) async throws {
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
