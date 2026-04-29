// ── FILE: Momentum/DI/AppDependencyContainer.swift ──

import SwiftUI
import SwiftData
import Core
import Domain
import Data
import Presentation

@Observable
final class AppDependencyContainer {

    private let networkClient: NetworkClientProtocol

    init() {
        networkClient = URLSessionNetworkClient()
    }

    func makeFeedView() -> some View {
        let repository = CharacterDataRepository(networkClient: networkClient)
        let useCase = FetchCharactersUseCase(repository: repository)
        return FeedBuilder(useCase: useCase).buildView()
    }

    func makeToDoView(modelContext: ModelContext) -> some View {
        let repository = ToDoDataRepository(modelContext: modelContext)
        let useCase = ToDoUseCase(repository: repository)
        return ToDoBuilder(useCase: useCase).buildView()
    }
}
