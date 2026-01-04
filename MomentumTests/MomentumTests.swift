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

    @MainActor
    @Test("Error message is set when fetch fails")
    func errorMessageSetOnFailure() async {
        let sut = FeedViewModel(
            feedUseCase: MockFeedUseCase(
                result: .failure(MockError.stub)
            )
        )

        #expect(sut.errorMessage == nil)

        await sut.loadData()

        #expect(sut.errorMessage != nil)
    }

    @MainActor
    @Test("Error message is cleared on retry")
    func errorMessageClearedOnRetry() async {
        let mockUseCase = MockFeedUseCase(
            result: .failure(MockError.stub)
        )
        let sut = FeedViewModel(feedUseCase: mockUseCase)

        await sut.loadData()
        #expect(sut.errorMessage != nil)

        mockUseCase.result = .success(
            FeedEntity(
                info: .init(count: 1, pages: 1),
                results: []
            )
        )

        await sut.loadData()
        #expect(sut.errorMessage == nil)
    }

    @MainActor
    @Test("Characters array is replaced on refresh")
    func charactersReplacedOnRefresh() async {
        let firstResponse = [
            CharactersResponse(id: 1, name: "First", species: "Human", image: nil)
        ]
        let secondResponse = [
            CharactersResponse(id: 2, name: "Second", species: "Alien", image: nil)
        ]

        let mockUseCase = MockFeedUseCase(
            result: .success(
                FeedEntity(
                    info: .init(count: 1, pages: 1),
                    results: firstResponse
                )
            )
        )
        let sut = FeedViewModel(feedUseCase: mockUseCase)

        await sut.loadData()
        #expect(sut.characters == firstResponse)

        mockUseCase.result = .success(
            FeedEntity(
                info: .init(count: 1, pages: 1),
                results: secondResponse
            )
        )

        await sut.loadData()
        #expect(sut.characters == secondResponse)
    }

    @MainActor
    @Test("Invalid URL error is handled correctly")
    func invalidURLError() async {
        let sut = FeedViewModel(
            feedUseCase: MockFeedUseCase(
                result: .failure(FeedViewModel.FeedError.invalidURL)
            )
        )

        await sut.loadData()

        #expect(sut.errorMessage == "Invalid feed URL configuration")
        #expect(sut.characters.isEmpty)
    }

    @MainActor
    @Test("Characters persist when error occurs on refresh")
    func charactersPersistOnRefreshError() async {
        let initialResponse = [
            CharactersResponse(id: 1, name: "Persisted", species: "Human", image: nil)
        ]

        let mockUseCase = MockFeedUseCase(
            result: .success(
                FeedEntity(
                    info: .init(count: 1, pages: 1),
                    results: initialResponse
                )
            )
        )
        let sut = FeedViewModel(feedUseCase: mockUseCase)

        await sut.loadData()
        #expect(sut.characters == initialResponse)

        mockUseCase.result = .failure(MockError.stub)

        await sut.loadData()
        #expect(sut.characters == initialResponse)
        #expect(sut.errorMessage != nil)
    }
}

private extension MomentumTests {
    
    enum MockError: Error {
        case stub
    }
}
