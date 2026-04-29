import SwiftUI

public struct ImageCacheKey: EnvironmentKey {
    public static let defaultValue = ImageCache()
}

public extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}
