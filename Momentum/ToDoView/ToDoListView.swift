import SwiftUI

struct ToDoListView: View {
    let viewModel: ToDoViewModel
    @State private var showingAddTodo = false

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle:
                    emptyStateView
                case .loading:
                    ProgressView()
                case .loaded:
                    todoListContent
                case .error(let error):
                    errorView(error)
                }
            }
            .navigationTitle("To-Do")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add", systemImage: "plus") {
                        showingAddTodo = true
                    }
                }
            }
            .sheet(isPresented: $showingAddTodo) {
                AddToDoView(viewModel: viewModel)
            }
            .task {
                if case .idle = viewModel.state {
                    await viewModel.loadTodos()
                }
            }
        }
    }

    private var todoListContent: some View {
        List {
            if !viewModel.activeTodos.isEmpty {
                Section("Active") {
                    ForEach(viewModel.activeTodos) { todo in
                        ToDoRowView(todo: todo, viewModel: viewModel)
                    }
                }
            }

            if !viewModel.completedTodos.isEmpty {
                Section("Completed") {
                    ForEach(viewModel.completedTodos) { todo in
                        ToDoRowView(todo: todo, viewModel: viewModel)
                    }
                }
            }

            if viewModel.todos.isEmpty {
                ContentUnavailableView(
                    "No To-Dos",
                    systemImage: "checkmark.circle",
                    description: Text("Tap the + button to add a new to-do")
                )
            }
        }
    }

    private var emptyStateView: some View {
        ContentUnavailableView(
            "No To-Dos",
            systemImage: "checkmark.circle",
            description: Text("Tap the + button to add a new to-do")
        )
    }

    private func errorView(_ error: Error) -> some View {
        ContentUnavailableView(
            "Error",
            systemImage: "exclamationmark.triangle",
            description: Text(error.localizedDescription)
        )
    }
}
