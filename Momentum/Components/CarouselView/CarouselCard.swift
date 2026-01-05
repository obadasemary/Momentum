//
//  CarouselCard.swift
//  Momentum
//
//  Created by Abdelrahman Mohamed on 03.01.2026.
//

import SwiftUI

struct CarouselCard: View {
    
    let character: CharactersResponse
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            ImageLoaderView(url: character.image)
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

#Preview {
    CarouselCard(
        character: .init(
            id: 1,
            name: "Obada",
            species: "Human",
            image: URL(
                string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"
            )
        )
    )
}
