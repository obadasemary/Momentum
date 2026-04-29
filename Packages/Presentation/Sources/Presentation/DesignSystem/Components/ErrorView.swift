import SwiftUI

public struct ErrorView: View {
    let message: String
    let retryAction: () async -> Void

    public init(message: String, retryAction: @escaping () async -> Void) {
        self.message = message
        self.retryAction = retryAction
    }

    public var body: some View {
        ContentUnavailableView {
            Label("Something went wrong", systemImage: "exclamationmark.triangle")
        } description: {
            Text(message)
        } actions: {
            Button("Try Again") {
                Task { await retryAction() }
            }
            .buttonStyle(.bordered)
        }
    }
}
