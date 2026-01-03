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
    
    @MainActor
    @Test("Loading state becomes false after fetch")
    func loadingStateToggle() async {
     
        let sut = FeedViewModel(
            feedUseCase: MockFeedUseCase(
                result: .success(
                    .init(
                        info: .init(
                            count: 0,
                            pages: 0
                        ),
                        results: []
                    )
                )
            )
        )
        
        #expect(sut.isLoading == false)
        
        let loadTask = Task { await sut.loadData() }
        
        await loadTask.value
        
        #expect(sut.isLoading == false)
    }
}

private extension MomentumTests {
    
    enum MockError: Error {
        case stub
    }
}
