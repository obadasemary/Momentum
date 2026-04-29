import Foundation
import Domain

final class MockFetchFeedUseCase: FetchFeedUseCaseProtocol, @unchecked Sendable {
    var result: Result<CharacterFeed, Error> = .success(
        CharacterFeed(
            info: CharacterInfo(totalCount: 0, totalPages: 1, hasNextPage: false),
            characters: []
        )
    )

    func execute(page: Int) async throws -> CharacterFeed {
        switch result {
        case .success(let feed): return feed
        case .failure(let error): throw error
        }
    }
}
