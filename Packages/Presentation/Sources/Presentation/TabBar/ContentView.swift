import SwiftUI

public struct ContentView: View {
    let feedBuilder: FeedBuilder
    let toDoBuilder: ToDoBuilder

    public init(feedBuilder: FeedBuilder, toDoBuilder: ToDoBuilder) {
        self.feedBuilder = feedBuilder
        self.toDoBuilder = toDoBuilder
    }

    public var body: some View {
        TabView {
            Tab("Feed", systemImage: "person.3") {
                feedBuilder.buildView()
            }

            Tab("To-Do", systemImage: "checkmark.circle") {
                toDoBuilder.buildView()
            }
        }
    }
}
