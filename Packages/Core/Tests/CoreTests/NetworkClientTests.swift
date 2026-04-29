// ── FILE: Packages/Core/Tests/CoreTests/NetworkClientTests.swift ──

import Testing
import Foundation
@testable import Core

struct NetworkClientTests {

    @Test("Send returns decoded value on 200 response")
    func sendReturnsDecodedValueOnSuccess() async throws {
        let payload = TestPayload(value: "hello")
        let data = try JSONEncoder().encode(payload)
        let url = try #require(URL(string: "https://example.com"))
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let session = MockURLSession(data: data, response: response)
        let sut = URLSessionNetworkClient(session: session)

        let result: TestPayload = try await sut.send(URLRequest(url: url))

        #expect(result.value == "hello")
    }

    @Test("Send throws invalidResponse on non-2xx status")
    func sendThrowsOnNon2xxStatus() async throws {
        let url = try #require(URL(string: "https://example.com"))
        let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)!
        let session = MockURLSession(data: Data(), response: response)
        let sut = URLSessionNetworkClient(session: session)

        await #expect(throws: NetworkError.self) {
            let _: TestPayload = try await sut.send(URLRequest(url: url))
        }
    }

    @Test("Send throws decodingFailed on malformed JSON")
    func sendThrowsDecodingFailedOnBadJSON() async throws {
        let url = try #require(URL(string: "https://example.com"))
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let session = MockURLSession(data: Data("bad".utf8), response: response)
        let sut = URLSessionNetworkClient(session: session)

        await #expect(throws: NetworkError.self) {
            let _: TestPayload = try await sut.send(URLRequest(url: url))
        }
    }
}

private struct TestPayload: Codable, Sendable {
    let value: String
}

private final class MockURLSession: URLSession, @unchecked Sendable {
    private let data: Data
    private let response: URLResponse

    init(data: Data, response: URLResponse) {
        self.data = data
        self.response = response
    }

    override func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        (data, response)
    }
}
