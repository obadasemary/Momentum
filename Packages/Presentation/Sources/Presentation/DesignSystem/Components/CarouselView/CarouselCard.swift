// ── FILE: Packages/Presentation/Sources/Presentation/DesignSystem/Components/CarouselView/CarouselCard.swift ──

import SwiftUI
import Domain

public struct CarouselCard: View {

    let character: CharacterEntity

    public init(character: CharacterEntity) {
        self.character = character
    }

    public var body: some View {
        ZStack(alignment: .bottomLeading) {
            ImageLoaderView(url: character.imageURL)
                .frame(height: 220)
                .clipped()

            LinearGradient(
                colors: [.black.opacity(0.7), .clear],
                startPoint: .bottom,
                endPoint: .top
            )
            .frame(height: 90)
            .frame(maxWidth: .infinity, alignment: .bottom)

            VStack(alignment: .leading) {
                Text(character.name)
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)

                if let species = character.species, !species.isEmpty {
                    Text(species)
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.85))
                }
            }
            .padding(16)
        }
        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
