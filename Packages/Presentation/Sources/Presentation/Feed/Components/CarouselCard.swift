import SwiftUI
import Core
import Domain

struct CarouselCard: View {
    let character: Character

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let url = character.imageURL {
                CachedAsyncImage(url: url)
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            } else {
                Rectangle()
                    .foregroundStyle(.secondary.opacity(0.3))
            }
            LinearGradient(
                colors: [.clear, .black.opacity(0.7)],
                startPoint: .center,
                endPoint: .bottom
            )
            VStack(alignment: .leading) {
                Text(character.name)
                    .font(.rmTitle)
                    .foregroundStyle(.white)
                Text(character.species)
                    .font(.rmCaption)
                    .foregroundStyle(.white.opacity(0.8))
            }
            .padding()
        }
        .clipShape(.rect(cornerRadius: 16))
    }
}
