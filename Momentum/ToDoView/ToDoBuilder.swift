import Foundation
import SwiftUI
import SwiftData

final class ToDoBuilder {
    func buildToDoListView(modelContext: ModelContext, isUsingMock: Bool = false) -> some View {
        let repository: ToDoRepositoryProtocol

        if isUsingMock {
            repository = MockToDoRepository()
        } else {
            repository = ToDoRepository(modelContext: modelContext)
        }

        let useCase = ToDoUseCase(repository: repository)
        let viewModel = ToDoViewModel(useCase: useCase)

        return ToDoListView(viewModel: viewModel)
    }
}
