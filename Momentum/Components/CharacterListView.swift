//
//  CharacterListView.swift
//  Momentum
//
//  Created by Abdelrahman Mohamed on 04.01.2026.
//

import SwiftUI

struct CharacterListView: View {
    
    let characters: [CharactersResponse]
    
    var body: some View {
        LazyVStack {        
            ForEach(characters, id: \.id) { character in
                CharacterView(character: character)
            }
        }
    }
}

#Preview {
    CharacterListView(
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
