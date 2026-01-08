//
//  MomentumApp.swift
//  Momentum
//
//  Created by Abdelrahman Mohamed on 29.12.2025.
//

import SwiftUI
import SwiftData

@main
struct MomentumApp: App {

    @State private var feedBuilder = FeedBuilder()
    @State private var todoBuilder = ToDoBuilder()

    var body: some Scene {
        WindowGroup {
            ContentView(feedBuilder: feedBuilder, todoBuilder: todoBuilder)
        }
        .modelContainer(for: ToDoModel.self)
    }
}
