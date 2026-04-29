import SwiftUI

public struct CachedAsyncImage: View {
    @Environment(\.imageCache) private var cache
    let url: URL?
    @State private var imageData: Data?

    public init(url: URL?) {
        self.url = url
    }

    public var body: some View {
        Group {
            if let data = imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    Color(.systemFill)
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                .task(id: url) {
                    await loadImage()
                }
            }
        }
    }

    private func loadImage() async {
        guard let url else { return }
        if let cached = await cache.image(for: url) {
            imageData = cached
            return
        }
        guard let data = try? await URLSession.shared.data(from: url).0 else { return }
        await cache.store(data, for: url)
        imageData = data
    }
}
