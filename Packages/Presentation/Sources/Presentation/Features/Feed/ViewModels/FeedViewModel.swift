// ── FILE: Packages/Presentation/Sources/Presentation/Features/Feed/ViewModels/FeedViewModel.swift ──

import Foundation
import Observation
import Domain

@Observable
public final class FeedViewModel {

    private let useCase: FetchCharactersUseCaseProtocol
    private let debugDelay: Duration

    public private(set) var characters: [CharacterEntity] = []
    public private(set) var isLoading = false
    public private(set) var errorMessage: String?

    public init(useCase: FetchCharactersUseCaseProtocol, debugDelay: Duration = .zero) {
        self.useCase = useCase
        self.debugDelay = debugDelay
    }

    public func loadData() async {
        isLoading = true
        errorMessage = nil

        do {
            #if DEBUG
            if debugDelay > .zero {
                try? await Task.sleep(for: debugDelay)
            }
            #endif
            let page = try await useCase.execute(page: 1)
            characters = page.characters
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
