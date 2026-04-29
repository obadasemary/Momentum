// ── FILE: Momentum/MomentumApp.swift ──

import SwiftUI
import SwiftData
import Data

@main
struct MomentumApp: App {

    @State private var container = AppDependencyContainer()

    var body: some Scene {
        WindowGroup {
            ContentView(container: container)
        }
        .modelContainer(for: ToDoModel.self)
    }
}
