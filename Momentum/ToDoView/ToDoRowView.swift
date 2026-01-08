import SwiftUI

struct ToDoRowView: View {
    let todo: ToDoEntity
    @State var viewModel: ToDoViewModel

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Button {
                Task {
                    await viewModel.toggleCompletion(todo.id)
                }
            } label: {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(todo.isCompleted ? .green : .secondary)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(todo.title)
                    .strikethrough(todo.isCompleted)
                    .foregroundStyle(todo.isCompleted ? .secondary : .primary)

                if let notes = todo.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }

            Spacer()
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button("Delete", systemImage: "trash", role: .destructive) {
                Task {
                    await viewModel.deleteTodo(todo.id)
                }
            }
        }
    }
}
