//
//  FeedEntity.swift
//  Momentum
//
//  Created by Abdelrahman Mohamed on 03.01.2026.
//

import Foundation

struct FeedEntity: Decodable {
    
    let info: InfoResponse
    let results: [CharactersResponse]
}

struct InfoResponse: Decodable {

    let count: Int
    let pages: Int

    init(count: Int, pages: Int) {
        self.count = count
        self.pages = pages
    }
}

struct CharactersResponse: Decodable, Identifiable, Equatable {

    let id: Int
    let name: String
    let species: String?
    let image: URL?

    init(id: Int, name: String, species: String?, image: URL?) {
        self.id = id
        self.name = name
        self.species = species
        self.image = image
    }
}
