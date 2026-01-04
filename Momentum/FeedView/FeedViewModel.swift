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
    private let debugDelay: Duration

    private(set) var characters: [CharactersResponse] = []
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String?

    init(feedUseCase: FeedUseCaseProtocol, debugDelay: Duration = .zero) {
        self.feedUseCase = feedUseCase
        self.debugDelay = debugDelay
    }
    
    func loadData() async {
        
        isLoading = true

        do {
            #if DEBUG
            if debugDelay > .zero {
                try? await Task.sleep(for: debugDelay)
            }
            #endif
            try await fetchFeed()
        } catch {
            errorMessage  = error.localizedDescription
        }
        
        isLoading = false
    }
}

private extension FeedViewModel {
    
    func fetchFeed() async throws {
        guard let url = Constants.url else {
            return
        }
        
        let response = try await feedUseCase.fetchFeed(url: url)
        characters = response.results
    }
}
