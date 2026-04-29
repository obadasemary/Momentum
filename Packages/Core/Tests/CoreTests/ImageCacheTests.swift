// ── FILE: Packages/Core/Tests/CoreTests/ImageCacheTests.swift ──

import Testing
import UIKit
@testable import Core

struct ImageCacheTests {

    @Test("Stored image is retrievable by URL")
    func storedImageIsRetrievable() async throws {
        let cache = ImageCache()
        let url = try #require(URL(string: "https://example.com/img.png"))
        let image = UIImage()

        await cache.store(image, for: url)
        let retrieved = await cache.image(for: url)

        #expect(retrieved != nil)
    }

    @Test("Non-stored URL returns nil")
    func nonStoredURLReturnsNil() async throws {
        let cache = ImageCache()
        let url = try #require(URL(string: "https://example.com/missing.png"))

        let result = await cache.image(for: url)

        #expect(result == nil)
    }

    @Test("removeAll clears all cached images")
    func removeAllClearsCache() async throws {
        let cache = ImageCache()
        let url = try #require(URL(string: "https://example.com/img.png"))

        await cache.store(UIImage(), for: url)
        await cache.removeAll()

        let result = await cache.image(for: url)
        #expect(result == nil)
    }
}
