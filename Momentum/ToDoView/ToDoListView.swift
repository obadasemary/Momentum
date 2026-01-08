import SwiftUI

struct ToDoListView: View {

    @State var viewModel: ToDoViewModel
    @State private var showingAddTodo = false
    @State private var showingError = false

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
                case .error(_, let preservedData):
                    if preservedData != nil {
                        todoListContent
                    } else {
                        errorView
                    }
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
            .alert("Error", isPresented: $showingError) {
                Button("OK") {
                    showingError = false
                }
            } message: {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                }
            }
            .onChange(of: viewModel.errorMessage) {
                if viewModel.errorMessage != nil {
                    showingError = true
                }
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

    private var errorView: some View {
        ContentUnavailableView(
            "Error",
            systemImage: "exclamationmark.triangle",
            description: Text(viewModel.errorMessage ?? "An error occurred")
        )
    }
}
