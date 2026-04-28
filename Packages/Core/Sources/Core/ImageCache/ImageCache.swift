import Foundation

// actor isolates concurrent reads/writes without manual locking; escapes defaultIsolation(MainActor).
public actor ImageCache {
    private var cache: [URL: Data] = [:]

    public init() {}

    public func image(for url: URL) -> Data? {
        cache[url]
    }

    public func store(_ data: Data, for url: URL) {
        cache[url] = data
    }

    public func clear() {
        cache.removeAll()
    }
}
