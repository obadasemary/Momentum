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
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.5))
                        .frame(height: 220)
                        .padding(.horizontal)
                        .redacted(reason: .placeholder)
                        .padding(.bottom)
                    
                } else if viewModel.characters.isEmpty {
                    ContentUnavailableView(
                        "No Feed",
                        systemImage: "network.slash",
                        description: Text("Pull to refresh")
                    )
                } else {
                    CarouselView(characters: viewModel.characters)
                    
                    ForEach(viewModel.characters, id: \.id) { character in
                        CharacterView(character: character)
                    }
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

#Preview {
    let feedBuilder = FeedBuilder()
    
    feedBuilder
        .buildFeedView(isUsingMock: true)
}
