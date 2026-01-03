//
//  MockFeedRepository.swift
//  Momentum
//
//  Created by Abdelrahman Mohamed on 03.01.2026.
//

import Foundation

class MockFeedRepository: FeedRepositoryProtocol {
    
    func fetchFeed(url: URL) async throws -> FeedEntity {
        FeedEntity(
            info: .init(
                count: 1,
                pages: 1
            ),
            results: [
                .init(
                    id: 1,
                    name: "Obada",
                    image: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
                ),
                .init(
                    id: 2,
                    name: "Sara",
                    image: URL(string: "https://rickandmortyapi.com/api/character/avatar/2.jpeg")
                )
                ,
                .init(
                    id: 3,
                    name: "Nazli",
                    image: URL(string: "https://rickandmortyapi.com/api/character/avatar/3.jpeg")
                )
            ]
        )
    }
}
