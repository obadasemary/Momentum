import Foundation

final class MockURLProtocol: URLProtocol, @unchecked Sendable {
    static var stubbedData: Data = Data()
    static var stubbedStatusCode: Int = 200
    static var stubbedError: Error?

    static func stub(data: Data, statusCode: Int) {
        stubbedData = data
        stubbedStatusCode = statusCode
        stubbedError = nil
    }

    static func stubError(_ error: Error) {
        stubbedError = error
    }

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        if let error = MockURLProtocol.stubbedError {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        let response = HTTPURLResponse(
            url: request.url!,
            statusCode: MockURLProtocol.stubbedStatusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: MockURLProtocol.stubbedData)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
