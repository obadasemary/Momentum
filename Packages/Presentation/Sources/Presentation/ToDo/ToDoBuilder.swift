import SwiftUI
import Domain

public final class ToDoBuilder {
    private let useCase: any ToDoUseCaseProtocol

    public init(useCase: any ToDoUseCaseProtocol) {
        self.useCase = useCase
    }

    public func buildView() -> some View {
        ToDoListView(viewModel: ToDoViewModel(useCase: useCase))
    }
}
