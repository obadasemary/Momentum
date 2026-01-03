//
//  NetworkService.swift
//  Momentum
//
//  Created by Abdelrahman Mohamed on 03.01.2026.
//

import Foundation

protocol NetworkServiceProtocol {
    func execute<T: Decodable>(_ request: URLRequest) async throws -> T
}

final class NetworkService {
    
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}

extension NetworkService: NetworkServiceProtocol {
    
    func execute<T: Decodable>(_ request: URLRequest) async throws -> T {
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse
                , (200...299).contains(httpResponse.statusCode) else {
            throw NetworkServiceError.invalidResponse
        }
        
        do {
            let decoadedResponse = try JSONDecoder().decode(T.self, from: data)
            return decoadedResponse
        } catch {
            throw NetworkServiceError.decodingError
        }
    }
}

enum NetworkServiceError: Error {
    case invalidResponse
    case decodingError
}

