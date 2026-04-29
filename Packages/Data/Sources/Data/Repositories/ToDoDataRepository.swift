// ── FILE: Packages/Data/Sources/Data/Repositories/ToDoDataRepository.swift ──

import Foundation
import SwiftData
import Domain

public final class ToDoDataRepository: ToDoRepositoryProtocol {

    private let modelContext: ModelContext

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    public func fetchAll() async throws -> [ToDoEntity] {
        let descriptor = FetchDescriptor<ToDoModel>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor).map { $0.toEntity() }
    }

    public func create(title: String, notes: String?) async throws -> ToDoEntity {
        let model = ToDoModel(title: title, notes: notes)
        modelContext.insert(model)
        try modelContext.save()
        return model.toEntity()
    }

    public func update(_ todo: ToDoEntity) async throws {
        let id = todo.id
        let descriptor = FetchDescriptor<ToDoModel>(
            predicate: #Predicate { $0.id == id }
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
