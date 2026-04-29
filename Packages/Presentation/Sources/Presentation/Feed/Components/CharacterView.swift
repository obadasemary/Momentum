import SwiftUI
import Core
import Domain

public struct CharacterView: View {
    let character: Character

    public init(character: Character) {
        self.character = character
    }

    public var body: some View {
        HStack {
            Group {
                if let url = character.imageURL {
                    CachedAsyncImage(url: url)
                        .frame(width: 60, height: 60)
                        .clipShape(.rect(cornerRadius: 8))
                } else {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundStyle(.secondary)
                }
            }
            VStack(alignment: .leading) {
                Text(character.name)
                    .font(.rmHeadline)
                Text(character.species)
                    .font(.rmCaption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
