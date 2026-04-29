// ── FILE: Packages/Presentation/Sources/Presentation/DesignSystem/Components/CarouselView/CarouselView.swift ──

import SwiftUI
import Domain

public struct CarouselView: View {

    let characters: [CharacterEntity]

    public init(characters: [CharacterEntity]) {
        self.characters = characters
    }

    public var body: some View {
        if !characters.isEmpty {
            TabView {
                ForEach(characters, id: \.id) { character in
                    CarouselCard(character: character)
                        .padding(.horizontal)
                }
            }
            #if os(iOS)
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            #endif
            .frame(height: 220)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding(.top)
        }
    }
}
