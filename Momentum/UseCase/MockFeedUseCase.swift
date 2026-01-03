//
//  MockFeedUseCase.swift
//  Momentum
//
//  Created by Abdelrahman Mohamed on 03.01.2026.
//

import Foundation

final class MockFeedUseCase: FeedUseCaseProtocol {
    
    private let result: Result<FeedEntity, Error>
    
    init(result: Result<FeedEntity, Error>) {
        self.result = result
    }
    
    func fetchFeed(url: URL) async throws -> FeedEntity {
        switch result {
        case .success(let success):
            success
        case .failure(let failure):
            throw failure
        }
    }
}
