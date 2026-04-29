import Testing
import Foundation
@testable import Presentation
import Domain

@MainActor
@Suite("FeedViewModel")
struct FeedViewModelTests {
    private func makeFeed(characters: [Character] = [], hasNextPage: Bool = false) -> CharacterFeed {
        CharacterFeed(
            info: CharacterInfo(totalCount: characters.count, totalPages: 1, hasNextPage: hasNextPage),
            characters: characters
        )
    }

    private func makeCharacter(id: Int = 1, name: String = "Rick") -> Character {
        Character(id: id, name: name, species: "Human", imageURL: nil)
    }

    @Test("Initial state is idle")
    func initialStateIsIdle() {
        let mock = MockFetchFeedUseCase()
        let vm = FeedViewModel(fetchFeed: mock)
        if case .idle = vm.state {} else {
            Issue.record("Expected idle state")
        }
    }

    @Test("load() transitions to loading then loaded")
    func loadTransitionsToLoaded() async throws {
        let mock = MockFetchFeedUseCase()
        let character = makeCharacter()
        mock.result = .success(makeFeed(characters: [character]))
        let vm = FeedViewModel(fetchFeed: mock)

        await vm.load()

        #expect(vm.characters.count == 1)
        #expect(vm.characters.first?.name == "Rick")
    }

    @Test("load() on non-idle state is a no-op")
    func loadWhenNotIdleIsNoOp() async {
        let mock = MockFetchFeedUseCase()
        mock.result = .success(makeFeed(characters: [makeCharacter()]))
        let vm = FeedViewModel(fetchFeed: mock)

        await vm.load()
        let countAfterFirst = vm.characters.count

        mock.result = .success(makeFeed(characters: [makeCharacter(id: 2), makeCharacter(id: 3)]))
        await vm.load() // should be no-op because state is now .loaded

        #expect(vm.characters.count == countAfterFirst)
    }

    @Test("load() on error transitions to error state")
    func loadOnErrorTransitionsToErrorState() async {
        let mock = MockFetchFeedUseCase()
        mock.result = .failure(URLError(.notConnectedToInternet))
        let vm = FeedViewModel(fetchFeed: mock)

        await vm.load()

        #expect(vm.errorMessage != nil)
        #expect(vm.characters.isEmpty)
    }

    @Test("refresh() resets and reloads")
    func refreshResetsAndReloads() async {
        let mock = MockFetchFeedUseCase()
        mock.result = .success(makeFeed(characters: [makeCharacter()]))
        let vm = FeedViewModel(fetchFeed: mock)
        await vm.load()

        mock.result = .success(makeFeed(characters: [makeCharacter(id: 2, name: "Morty")]))
        await vm.refresh()

        #expect(vm.characters.count == 1)
        #expect(vm.characters.first?.name == "Morty")
    }

    @Test("loadMore() appends characters when hasNextPage is true")
    func loadMoreAppendsCharacters() async {
        let mock = MockFetchFeedUseCase()
        mock.result = .success(makeFeed(characters: [makeCharacter(id: 1)], hasNextPage: true))
        let vm = FeedViewModel(fetchFeed: mock)
        await vm.load()

        mock.result = .success(makeFeed(characters: [makeCharacter(id: 2, name: "Morty")], hasNextPage: false))
        await vm.loadMore()

        #expect(vm.characters.count == 2)
    }

    @Test("loadMore() is a no-op when hasNextPage is false")
    func loadMoreNoOpWhenNoNextPage() async {
        let mock = MockFetchFeedUseCase()
        mock.result = .success(makeFeed(characters: [makeCharacter()], hasNextPage: false))
        let vm = FeedViewModel(fetchFeed: mock)
        await vm.load()

        await vm.loadMore()

        #expect(vm.characters.count == 1)
    }

    @Test("isLoading is true only during loading state")
    func isLoadingReflectsState() async {
        let mock = MockFetchFeedUseCase()
        mock.result = .success(makeFeed())
        let vm = FeedViewModel(fetchFeed: mock)

        #expect(!vm.isLoading)
        await vm.load()
        #expect(!vm.isLoading)
    }
}
