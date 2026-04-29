// ── FILE: Packages/Presentation/Sources/Presentation/Features/Feed/Builder/FeedBuilder.swift ──

import SwiftUI
import Domain

public struct FeedBuilder {

    private let useCase: FetchCharactersUseCaseProtocol

    public init(useCase: FetchCharactersUseCaseProtocol) {
        self.useCase = useCase
    }

    public func buildView(debugDelay: Duration = .zero) -> some View {
        let viewModel = FeedViewModel(useCase: useCase, debugDelay: debugDelay)
        return FeedView(viewModel: viewModel)
    }
}
