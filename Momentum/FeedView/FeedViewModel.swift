//
//  FeedViewModel.swift
//  Momentum
//
//  Created by Abdelrahman Mohamed on 03.01.2026.
//

import Foundation

@Observable
final class FeedViewModel {
    
    private let feedUseCase: FeedUseCaseProtocol
    
    private(set) var characters: [CharactersResponse] = []
    
    init(feedUseCase: FeedUseCaseProtocol) {
        self.feedUseCase = feedUseCase
    }
}
