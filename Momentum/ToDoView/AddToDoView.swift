import SwiftUI

struct AddToDoView: View {
    
    @State var viewModel: ToDoViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $title)
                }

                Section("Notes") {
                    TextField("Add notes (optional)", text: $notes, axis: .vertical)
                        .lineLimit(5...10)
                }
            }
            .navigationTitle("New To-Do")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        Task {
                            await addTodo()
                        }
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func addTodo() async {
        let trimmedNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        await viewModel.createTodo(
            title: title,
            notes: trimmedNotes.isEmpty ? nil : trimmedNotes
        )
        dismiss()
    }
}
