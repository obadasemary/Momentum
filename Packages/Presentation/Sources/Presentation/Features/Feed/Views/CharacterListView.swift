// ── FILE: Packages/Presentation/Sources/Presentation/Features/Feed/Views/CharacterListView.swift ──

import SwiftUI
import Domain

public struct CharacterListView: View {

    let characters: [CharacterEntity]

    public init(characters: [CharacterEntity]) {
        self.characters = characters
    }

    public var body: some View {
        LazyVStack {
            ForEach(characters, id: \.id) { character in
                CharacterView(character: character)
            }
        }
    }
}
