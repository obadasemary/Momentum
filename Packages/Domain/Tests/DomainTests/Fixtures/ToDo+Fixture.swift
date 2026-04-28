import Foundation
@testable import Domain

extension ToDo {
    static func fixture(
        id: UUID = UUID(),
        title: String = "Buy groceries",
        notes: String? = nil,
        isCompleted: Bool = false
    ) -> ToDo {
        ToDo(id: id, title: title, notes: notes, isCompleted: isCompleted)
    }
}
