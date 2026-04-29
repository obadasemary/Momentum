import SwiftUI
import Domain

public struct CharacterListView: View {
    let characters: [Character]
    let onAppearLast: (() -> Void)?

    public init(characters: [Character], onAppearLast: (() -> Void)? = nil) {
        self.characters = characters
        self.onAppearLast = onAppearLast
    }

    public var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(characters) { character in
                CharacterView(character: character)
                    .onAppear {
                        if character.id == characters.last?.id {
                            onAppearLast?()
                        }
                    }
                Divider()
                    .padding(.leading, 84)
            }
        }
    }
}
