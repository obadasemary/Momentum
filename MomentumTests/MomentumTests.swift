// ── FILE: MomentumTests/MomentumTests.swift ──
// App-level integration smoke tests.
// Comprehensive unit tests live in the SPM package test targets:
//   Packages/Core/Tests/CoreTests
//   Packages/Domain/Tests/DomainTests
//   Packages/Data/Tests/DataTests
//   Packages/Presentation/Tests/PresentationTests

import Testing
import Foundation
import Core
import Domain
import Presentation
@testable import Momentum

@Suite("App Smoke Tests")
struct MomentumTests {

    @Test("URLSessionNetworkClient initialises")
    func networkClientInitialises() {
        let client = URLSessionNetworkClient()
        #expect(client != nil)
    }

    @Test("ToDoEntity initialises with correct defaults")
    func toDoEntityDefaults() {
        let entity = ToDoEntity(title: "Smoke test")
        #expect(entity.title == "Smoke test")
        #expect(entity.isCompleted == false)
        #expect(entity.notes == nil)
    }

    @Test("CharacterEntity initialises correctly")
    func characterEntityInitialises() {
        let entity = CharacterEntity(id: 42, name: "Rick", species: "Human", imageURL: nil)
        #expect(entity.id == 42)
        #expect(entity.name == "Rick")
    }

    @Test("FeedViewModel starts with empty characters")
    func feedViewModelInitialState() {
        final class StubUseCase: FetchCharactersUseCaseProtocol {
            func execute(page: Int) async throws -> CharacterPageEntity {
                CharacterPageEntity(totalCount: 0, totalPages: 1, characters: [])
            }
        }
        let vm = FeedViewModel(useCase: StubUseCase())
        #expect(vm.characters.isEmpty)
        #expect(vm.isLoading == false)
        #expect(vm.errorMessage == nil)
    }

    @Test("FeedViewModel loads characters successfully")
    func feedViewModelLoadsCharacters() async {
        final class StubUseCase: FetchCharactersUseCaseProtocol {
            func execute(page: Int) async throws -> CharacterPageEntity {
                CharacterPageEntity(
                    totalCount: 1,
                    totalPages: 1,
                    characters: [CharacterEntity(id: 1, name: "Rick", species: "Human", imageURL: nil)]
                )
            }
        }
        let vm = FeedViewModel(useCase: StubUseCase())
        await vm.loadData()
        #expect(vm.characters.count == 1)
    }

    @Test("ToDoViewModel starts in idle state")
    func toDoViewModelInitialState() {
        final class StubUseCase: ToDoUseCaseProtocol {
            func fetchAll() async throws -> [ToDoEntity] { [] }
            func create(title: String, notes: String?) async throws -> ToDoEntity { ToDoEntity(title: title) }
            func update(_ todo: ToDoEntity) async throws {}
            func delete(_ id: UUID) async throws {}
            func toggleCompletion(_ id: UUID) async throws {}
        }
        let vm = ToDoViewModel(useCase: StubUseCase())
        if case .idle = vm.state { } else {
            Issue.record("Expected idle state")
        }
    }
}
