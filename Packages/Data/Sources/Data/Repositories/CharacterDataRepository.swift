// ── FILE: Packages/Data/Sources/Data/Repositories/CharacterDataRepository.swift ──

import Core
import Domain

public final class CharacterDataRepository: CharacterRepositoryProtocol {

    private let networkClient: NetworkClientProtocol

    public init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    public func fetchCharacters(page: Int) async throws -> CharacterPageEntity {
        let request = try CharacterEndpoint.characters(page: page)
        let dto: CharacterPageResponseDTO = try await networkClient.send(request)
        return CharacterMapper.toPageEntity(dto)
    }
}
