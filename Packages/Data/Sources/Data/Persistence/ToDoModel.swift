import Foundation
import SwiftData
import Domain

@Model
public final class ToDoModel {
    public var id: UUID
    public var title: String
    public var notes: String?
    public var isCompleted: Bool
    public var createdAt: Date
    public var completedAt: Date?

    public init(
        id: UUID = UUID(),
        title: String = "",
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

    public func toDomain() -> ToDo {
        ToDo(
            id: id,
            title: title,
            notes: notes,
            isCompleted: isCompleted,
            createdAt: createdAt,
            completedAt: completedAt
        )
    }

    public static func from(_ entity: ToDo) -> ToDoModel {
        ToDoModel(
            id: entity.id,
            title: entity.title,
            notes: entity.notes,
            isCompleted: entity.isCompleted,
            createdAt: entity.createdAt,
            completedAt: entity.completedAt
        )
    }
}
