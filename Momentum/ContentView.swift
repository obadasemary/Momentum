import SwiftUI
import SwiftData

struct ContentView: View {
    let feedBuilder: FeedBuilder
    let todoBuilder: ToDoBuilder

    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            Tab("Feed", systemImage: "person.3") {
                feedBuilder.buildFeedView()
            }

            Tab("To-Do", systemImage: "checkmark.circle") {
                todoBuilder.buildToDoListView(modelContext: modelContext)
            }
        }
    }
}
