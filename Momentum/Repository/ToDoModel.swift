import Foundation
import SwiftData

@Model
final class ToDoModel {
    var id: UUID
    var title: String
    var notes: String?
    var isCompleted: Bool
    var createdAt: Date
    var completedAt: Date?

    init(
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

    @MainActor
    func toEntity() -> ToDoEntity {
        ToDoEntity(
            id: id,
            title: title,
            notes: notes,
            isCompleted: isCompleted,
            createdAt: createdAt,
            completedAt: completedAt
        )
    }
}
