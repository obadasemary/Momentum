//
//  ImageLoaderView.swift
//  Momentum
//
//  Created by Abdelrahman Mohamed on 03.01.2026.
//

import SwiftUI

/// Displays an image from a URL with loading and error states.
/// Image caching is handled by URLCache configured in MomentumApp.
struct ImageLoaderView: View {
    
    let url: URL?
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.quinary)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .failure:
                Image(systemName: "exclamationmark.trianglepath.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.quinary)
                
            @unknown default:
                EmptyView()
            }
        }
    }
}

#Preview {
    ImageLoaderView(url: Constants.randomImageURL())
}
