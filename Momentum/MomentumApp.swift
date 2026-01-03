//
//  MomentumApp.swift
//  Momentum
//
//  Created by Abdelrahman Mohamed on 29.12.2025.
//

import SwiftUI

@main
struct MomentumApp: App {
    
    @State private var feedBuilder = FeedBuilder()
    
    var body: some Scene {
        WindowGroup {
            feedBuilder.buildFeedView()
        }
    }
}
