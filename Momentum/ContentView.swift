// ── FILE: Momentum/ContentView.swift ──

import SwiftUI

struct ContentView: View {

    let container: AppDependencyContainer

    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            Tab("Feed", systemImage: "person.3") {
                container.makeFeedView()
            }

            Tab("To-Do", systemImage: "checkmark.circle") {
                container.makeToDoView(modelContext: modelContext)
            }
        }
    }
}
