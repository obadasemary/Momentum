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

    init() {
        configureURLCache()
    }

    var body: some Scene {
        WindowGroup {
            feedBuilder.buildFeedView()
        }
    }

    private func configureURLCache() {
        // Configure URLCache for AsyncImage caching
        // 50 MB memory cache, 100 MB disk cache
        let memoryCapacity = 50 * 1024 * 1024 // 50 MB
        let diskCapacity = 100 * 1024 * 1024 // 100 MB

        let cache = URLCache(
            memoryCapacity: memoryCapacity,
            diskCapacity: diskCapacity
        )
        URLCache.shared = cache
    }
}
