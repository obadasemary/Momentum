import SwiftUI
import Domain

public struct ToDoRowView: View {
    let toDo: ToDo
    let onToggle: () async -> Void
    let onDelete: () async -> Void

    public init(toDo: ToDo, onToggle: @escaping () async -> Void, onDelete: @escaping () async -> Void) {
        self.toDo = toDo
        self.onToggle = onToggle
        self.onDelete = onDelete
    }

    public var body: some View {
        HStack {
            Button {
                Task { await onToggle() }
            } label: {
                Image(systemName: toDo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(toDo.isCompleted ? .green : .secondary)
                    .imageScale(.large)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading) {
                Text(toDo.title)
                    .strikethrough(toDo.isCompleted)
                    .foregroundStyle(toDo.isCompleted ? .secondary : .primary)
                if let notes = toDo.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.rmCaption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                Task { await onDelete() }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
