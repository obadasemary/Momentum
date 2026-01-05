//
//  CarouselView.swift
//  Momentum
//
//  Created by Abdelrahman Mohamed on 03.01.2026.
//

import SwiftUI

struct CarouselView: View {
    
    let characters: [CharactersResponse]
    
    var body: some View {
        Group {
            if characters.isEmpty {
                EmptyView()
            } else {
                TabView {
                    ForEach(characters, id: \.id) { character in
                        CarouselCard(character: character)
                            .padding(.horizontal)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .automatic))
                .frame(height: 220)
                .clipShape(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                )
                .padding(.top)
            }
        }
    }
}

#Preview {
    CarouselView(
        characters: [
            .init(
                id: 1,
                name: "Obada",
                species: "Human",
                image: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
            ),
            .init(
                id: 2,
                name: "Sara",
                species: "Human",
                image: URL(string: "https://rickandmortyapi.com/api/character/avatar/2.jpeg")
            ),
            .init(
                id: 3,
                name: "Nazli",
                species: "Human",
                image: URL(string: "https://rickandmortyapi.com/api/character/avatar/3.jpeg")
            ),
            .init(
                id: 4,
                name: "Omar",
                species: "Human",
                image: URL(string: "https://rickandmortyapi.com/api/character/avatar/4.jpeg")
            )
        ]
    )
}
