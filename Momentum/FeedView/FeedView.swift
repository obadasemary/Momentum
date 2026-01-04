//
//  FeedView.swift
//  Momentum
//
//  Created by Abdelrahman Mohamed on 29.12.2025.
//

import SwiftUI

struct FeedView: View {

    @State var viewModel: FeedViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                if viewModel.isLoading && viewModel.characters.isEmpty {
                    
                    placeholderCarouselView
                    
                    ForEach(0..<4, id: \.self) { _ in
                        placeholderCharacterView
                    }
                    
                } else if viewModel.characters.isEmpty {
                    ContentUnavailableView(
                        "No Feed",
                        systemImage: "network.slash",
                        description: Text("Pull to refresh")
                    )
                } else {
                    CarouselView(characters: viewModel.characters)
                    CharacterListView(characters: viewModel.characters)
                }
            }
            .task {
                await viewModel.loadData()
            }
            .refreshable {
                await viewModel.loadData()
            }
            .navigationTitle("Feeds")
        }
    }
}

private extension FeedView {
    
    var placeholderCarouselView: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.5))
            .frame(height: 220)
            .padding(.horizontal)
            .redacted(reason: .placeholder)
            .padding(.bottom)
    }
    
    var placeholderCharacterView: some View {
        HStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.5))
                .frame(width: 100, height: 100)

            VStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 150, height: 24)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 100, height: 16)
            }

            Spacer()
        }
        .padding()
        .background(.regularMaterial.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
        .redacted(reason: .placeholder)
    }
}

#Preview("Default") {
    let feedBuilder = FeedBuilder()

    feedBuilder
        .buildFeedView(isUsingMock: true)
}

#Preview("With Loading Delay") {
    let feedBuilder = FeedBuilder()

    feedBuilder
        .buildFeedView(isUsingMock: true, debugDelay: .seconds(3))
}
