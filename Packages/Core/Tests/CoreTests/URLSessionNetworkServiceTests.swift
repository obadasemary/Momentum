import Testing
import Foundation
@testable import Core

@Suite("URLSessionNetworkService")
struct URLSessionNetworkServiceTests {

    private func makeSUT() -> URLSessionNetworkService {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        return URLSessionNetworkService(session: URLSession(configuration: config))
    }

    @Test("Decodes valid JSON response")
    func decodesValidJSONResponse() async throws {
        let payload = #"{"value":42}"#
        MockURLProtocol.stub(data: Data(payload.utf8), statusCode: 200)
        let sut = makeSUT()

        let result: TestPayload = try await sut.request(StubEndpoint())
        #expect(result.value == 42)
    }

    @Test("Throws invalidResponse on non-2xx status")
    func throwsOnBadStatus() async throws {
        MockURLProtocol.stub(data: Data(), statusCode: 404)
        let sut = makeSUT()

        await #expect(throws: NetworkError.self) {
            let _: TestPayload = try await sut.request(StubEndpoint())
        }
    }

    @Test("Throws decodingFailed on malformed JSON")
    func throwsOnMalformedJSON() async throws {
        MockURLProtocol.stub(data: Data("not json".utf8), statusCode: 200)
        let sut = makeSUT()

        await #expect(throws: NetworkError.self) {
            let _: TestPayload = try await sut.request(StubEndpoint())
        }
    }
}

private struct StubEndpoint: Endpoint {
    var baseURL: URL { URL(string: "https://example.com")! }
    var path: String { "/test" }
    var method: HTTPMethod { .get }
}

private struct TestPayload: Decodable, Sendable {
    let value: Int
}
