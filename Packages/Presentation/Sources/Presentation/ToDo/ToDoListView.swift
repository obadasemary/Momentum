import SwiftUI
import Domain

public struct ToDoListView: View {
    @State private var viewModel: ToDoViewModel
    @State private var showingAddToDo = false

    public init(viewModel: ToDoViewModel) {
        self._viewModel = State(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
            content
                .navigationTitle("To-Do")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Add Task", systemImage: "plus") {
                            showingAddToDo = true
                        }
                    }
                }
                .sheet(isPresented: $showingAddToDo) {
                    AddToDoView { title, notes in
                        await viewModel.addToDo(title: title, notes: notes)
                    }
                }
        }
        .task {
            await viewModel.load()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            Color.clear
        case .loading:
            LoadingView()
        case .empty:
            ContentUnavailableView(
                "No Tasks",
                systemImage: "checkmark.circle",
                description: Text("Tap + to add your first task.")
            )
        case .loaded:
            toDoList
        case .error(let error, let preserved):
            if let preserved, !preserved.isEmpty {
                toDoList
                    .overlay(alignment: .top) {
                        errorBanner(error.localizedDescription)
                    }
            } else {
                ErrorView(message: error.localizedDescription) {
                    await viewModel.refresh()
                }
            }
        }
    }

    private var toDoList: some View {
        List {
            if !viewModel.activeTodos.isEmpty {
                Section("Active") {
                    ForEach(viewModel.activeTodos) { toDo in
                        ToDoRowView(
                            toDo: toDo,
                            onToggle: { await viewModel.toggleCompletion(toDo) },
                            onDelete: { await viewModel.deleteToDo(toDo) }
                        )
                    }
                }
            }
            if !viewModel.completedTodos.isEmpty {
                Section("Completed") {
                    ForEach(viewModel.completedTodos) { toDo in
                        ToDoRowView(
                            toDo: toDo,
                            onToggle: { await viewModel.toggleCompletion(toDo) },
                            onDelete: { await viewModel.deleteToDo(toDo) }
                        )
                    }
                }
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
    }

    private func errorBanner(_ message: String) -> some View {
        Text(message)
            .font(.rmCaption)
            .foregroundStyle(.white)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(.red, in: .capsule)
            .padding()
    }
}
