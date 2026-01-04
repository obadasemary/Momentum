//
//  MockFeedUseCase.swift
//  Momentum
//
//  Created by Abdelrahman Mohamed on 03.01.2026.
//

import Foundation

final class MockFeedUseCase: FeedUseCaseProtocol {

    var result: Result<FeedEntity, Error>

    init(result: Result<FeedEntity, Error>) {
        self.result = result
    }

    func fetchFeed(url: URL) async throws -> FeedEntity {
        try result.get()
    }
}
