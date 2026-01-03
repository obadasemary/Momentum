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
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String?
    
    init(feedUseCase: FeedUseCaseProtocol) {
        self.feedUseCase = feedUseCase
    }
    
    func loadData() async {
        
        isLoading = true
        
        do {
            #if DEBUG
            try? await Task.sleep(for: .seconds(3))
            #endif
            try await fetchFeed()
        } catch {
            errorMessage  = error.localizedDescription
        }
        
        isLoading = false
    }
}

extension FeedViewModel {
    
    func fetchFeed() async throws {
        guard let url = Constants.url else {
            isLoading = false
            return
        }
        
        let response = try await feedUseCase.fetchFeed(url: url)
        characters = response.results
    }
}
