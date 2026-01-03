//
//  CharacterView.swift
//  Momentum
//
//  Created by Abdelrahman Mohamed on 04.01.2026.
//

import SwiftUI

struct CharacterView: View {
    
    let character: CharactersResponse
    private let imageSize: CGFloat = 100
    
    var body: some View {
        HStack(alignment: .top) {
            ImageLoaderView(url: character.image)
                .frame(width: imageSize, height: imageSize)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading) {
                Text(character.name)
                    .font(.title)
                    .foregroundStyle(.primary)

                Text(character.species ?? "")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(.regularMaterial.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 8))
//        .cornerRadius(16)
        .padding(.horizontal)
    }
}

#Preview {
    CharacterView(
        character: CharactersResponse(
            id: 1,
            name: "Obada",
            species: "Human",
            image: Constants.randomImageURL()
        )
    )
}
