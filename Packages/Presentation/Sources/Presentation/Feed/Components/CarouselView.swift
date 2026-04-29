import SwiftUI
import Domain

public struct CarouselView: View {
    let characters: [Character]

    public init(characters: [Character]) {
        self.characters = characters
    }

    public var body: some View {
        TabView {
            ForEach(characters) { character in
                CarouselCard(character: character)
                    .padding(.horizontal)
            }
        }
        .tabViewStyle(.page)
        .frame(height: 240)
    }
}
