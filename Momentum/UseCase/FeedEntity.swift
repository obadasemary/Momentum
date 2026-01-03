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
}

struct CharactersResponse: Decodable {
    
    let id: Int
    let name: String
    let image: URL?
}
