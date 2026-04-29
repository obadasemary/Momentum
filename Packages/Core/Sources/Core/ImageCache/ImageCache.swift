// ── FILE: Packages/Core/Sources/Core/ImageCache/ImageCache.swift ──

import SwiftUI

public actor ImageCache {

    public static let shared = ImageCache()

    private let cache = NSCache<NSURL, UIImage>()

    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024
    }

    public func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }

    public func store(_ image: UIImage, for url: URL) {
        let cost = Int(image.size.width * image.size.height * 4)
        cache.setObject(image, forKey: url as NSURL, cost: cost)
    }

    public func removeAll() {
        cache.removeAllObjects()
    }
}
