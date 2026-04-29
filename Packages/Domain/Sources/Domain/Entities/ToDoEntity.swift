// ── FILE: Packages/Domain/Sources/Domain/Entities/ToDoEntity.swift ──

import Foundation

public struct ToDoEntity: Identifiable, Hashable, Sendable {
    public let id: UUID
    public var title: String
    public var notes: String?
    public var isCompleted: Bool
    public var createdAt: Date
    public var completedAt: Date?

    public init(
        id: UUID = UUID(),
        title: String,
        notes: String? = nil,
        isCompleted: Bool = false,
        createdAt: Date = Date(),
        completedAt: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.notes = notes
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.completedAt = completedAt
    }
}
