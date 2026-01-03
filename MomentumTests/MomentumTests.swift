//
//  MomentumTests.swift
//  MomentumTests
//
//  Created by Abdelrahman Mohamed on 29.12.2025.
//

import Testing
@testable import Momentum

struct MomentumTests {

    @MainActor
    @Test("Test Fetch Feed With Success")
    func fetchFeedWithSuccess() async throws {
        
        let response = [
            CharactersResponse(
                id: 1,
                name: "Obada",
                species: "Human",
                image: nil
            ),
            CharactersResponse(
                id: 1,
                name: "Obada",
                species: "Human",
                image: nil
            )
        ]
        
        let makeSut = {
            MockFeedUseCase(
                result:
                        .success(
                            FeedEntity(
                                info: .init(count: 1, pages: 1),
                                results: response
                            )
                        )
            )
        }
        
        let viewModel = FeedViewModel(feedUseCase: makeSut())
        
        await viewModel.loadData()
        
        #expect(viewModel.characters == response)
    }
    
    @MainActor
    @Test("Test Fetch Feed With Failure")
    func fetchFeedWithFailure() async throws {
        
        let makeSut = {
            MockFeedUseCase(
                result:
                        .failure(MockError.stub)
            )
        }
        
        let viewModel = FeedViewModel(feedUseCase: makeSut())
        
        await viewModel.loadData()
        
        #expect(viewModel.characters.isEmpty)
    }
}

private extension MomentumTests {
    
    enum MockError: Error {
        case stub
    }
}
