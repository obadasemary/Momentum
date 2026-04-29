import SwiftUI
import Domain

public struct FeedView: View {
    @State private var viewModel: FeedViewModel

    public init(viewModel: FeedViewModel) {
        self._viewModel = State(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
            content
                .navigationTitle("Feed")
        }
        .task {
            await viewModel.load()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            Color.clear
        case .loading:
            LoadingView()
        case .loaded(let characters), .loadingMore(let characters):
            characterList(characters)
        case .error(let error):
            ErrorView(message: error.localizedDescription) {
                await viewModel.refresh()
            }
        }
    }

    private func characterList(_ characters: [Character]) -> some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                if characters.count >= 3 {
                    CarouselView(characters: Array(characters.prefix(3)))
                        .padding(.bottom)
                }
                CharacterListView(characters: characters) {
                    if !viewModel.isLoadingMore {
                        Task { await viewModel.loadMore() }
                    }
                }
                if viewModel.isLoadingMore {
                    ProgressView()
                        .padding()
                }
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
    }
}
