// ── FILE: Packages/Presentation/Tests/PresentationTests/FeedViewModelTests.swift ──

import Testing
import Foundation
import Domain
@testable import Presentation

@Suite("FeedViewModel")
struct FeedViewModelTests {

    @Test("Load data populates characters on success")
    func loadDataPopulatesCharacters() async throws {
        let characters = [
            CharacterEntity(id: 1, name: "Rick", species: "Human", imageURL: nil),
            CharacterEntity(id: 2, name: "Morty", species: "Human", imageURL: nil)
        ]
        let useCase = MockFetchCharactersUseCase()
        useCase.stubbedResult = .success(
            CharacterPageEntity(totalCount: 2, totalPages: 1, characters: characters)
        )
        let sut = FeedViewModel(useCase: useCase)

        await sut.loadData()

        #expect(sut.characters.count == 2)
        #expect(sut.errorMessage == nil)
        #expect(sut.isLoading == false)
    }

    @Test("Load data sets error message on failure")
    func loadDataSetsErrorOnFailure() async {
        let useCase = MockFetchCharactersUseCase()
        useCase.stubbedResult = .failure(TestError.networkFailed)
        let sut = FeedViewModel(useCase: useCase)

        await sut.loadData()

        #expect(sut.errorMessage != nil)
        #expect(sut.characters.isEmpty)
    }

    @Test("isLoading is false after load completes")
    func isLoadingFalseAfterLoad() async {
        let useCase = MockFetchCharactersUseCase()
        let sut = FeedViewModel(useCase: useCase)

        await sut.loadData()

        #expect(sut.isLoading == false)
    }

    @Test("Initial state has no characters and no error")
    func initialState() {
        let sut = FeedViewModel(useCase: MockFetchCharactersUseCase())

        #expect(sut.characters.isEmpty)
        #expect(sut.errorMessage == nil)
        #expect(sut.isLoading == false)
    }

    @Test("Error message cleared on successful reload")
    func errorMessageClearedOnReload() async {
        let useCase = MockFetchCharactersUseCase()
        useCase.stubbedResult = .failure(TestError.networkFailed)
        let sut = FeedViewModel(useCase: useCase)
        await sut.loadData()
        #expect(sut.errorMessage != nil)

        useCase.stubbedResult = .success(
            CharacterPageEntity(totalCount: 0, totalPages: 1, characters: [])
        )
        await sut.loadData()

        #expect(sut.errorMessage == nil)
    }
}

private enum TestError: Error {
    case networkFailed
}
