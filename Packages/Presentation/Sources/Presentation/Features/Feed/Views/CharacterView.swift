// ── FILE: Packages/Presentation/Sources/Presentation/Features/Feed/Views/CharacterView.swift ──

import SwiftUI
import Domain

public struct CharacterView: View {

    let character: CharacterEntity
    private let imageSize: CGFloat = 100

    public init(character: CharacterEntity) {
        self.character = character
    }

    public var body: some View {
        HStack(alignment: .top) {
            ImageLoaderView(url: character.imageURL)
                .frame(width: imageSize, height: imageSize)
                .clipShape(RoundedRectangle(cornerRadius: 16))

            VStack(alignment: .leading) {
                Text(character.name)
                    .font(.title)
                    .foregroundStyle(.primary)

                if let species = character.species, !species.isEmpty {
                    Text(species)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
        .padding()
        .background(.regularMaterial.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }
}
