// ── FILE: Packages/Presentation/Sources/Presentation/Features/ToDo/Builder/ToDoBuilder.swift ──

import SwiftUI
import Domain

public struct ToDoBuilder {

    private let useCase: ToDoUseCaseProtocol

    public init(useCase: ToDoUseCaseProtocol) {
        self.useCase = useCase
    }

    public func buildView() -> some View {
        let viewModel = ToDoViewModel(useCase: useCase)
        return ToDoListView(viewModel: viewModel)
    }
}
