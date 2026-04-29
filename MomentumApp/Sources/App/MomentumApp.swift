import SwiftUI
import SwiftData
import Core
import Data
import Presentation

@main
struct MomentumApp: App {
    private let container = AppDIContainer.shared

    var body: some Scene {
        WindowGroup {
            ContentViewWrapper(container: container)
                .environment(\.imageCache, container.imageCache)
        }
        .modelContainer(for: ToDoModel.self)
    }
}

private struct ContentViewWrapper: View {
    @Environment(\.modelContext) private var modelContext
    let container: AppDIContainer

    var body: some View {
        ContentView(
            feedBuilder: container.makeFeedBuilder(),
            toDoBuilder: container.makeToDoBuilder(modelContext: modelContext)
        )
    }
}
