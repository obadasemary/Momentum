//
//  FeedBuilder.swift
//  Momentum
//
//  Created by Abdelrahman Mohamed on 03.01.2026.
//

import Foundation
import SwiftUI

final class FeedBuilder {

    func buildFeedView(isUsingMock: Bool = false, debugDelay: Duration = .zero) -> some View {
        let feedRepository: FeedRepositoryProtocol

        if isUsingMock {
            feedRepository = MockFeedRepository()
        } else {
            let networkService = NetworkService(session: .shared)
            feedRepository = FeedRepository(networkService: networkService)
        }

        let feedUseCase = FeedUseCase(feedRepository: feedRepository)
        let viewModel = FeedViewModel(feedUseCase: feedUseCase, debugDelay: debugDelay)

        return FeedView(viewModel: viewModel)
    }
}
