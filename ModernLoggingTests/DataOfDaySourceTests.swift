//
//  DataOfDaySourceTests.swift
//  ModernLoggingTests
//
//  Created by Sucu, Ege on 2.01.2025.
//
import Foundation
import Testing
@testable import ModernLogging

struct DataOfDaySourceTests {

    @Test func testInitWithValidAPIURL() async {
        let validURL = "https://example.com/api/data-of-day"
        let mockBundle = MockBundle(infoDict: ["APIURL": validURL])

        async let source = DataOfDaySource(bundle: mockBundle)

        await #expect(source.url != nil)
        await #expect(source.url?.absoluteString == validURL)
    }

    @MainActor
    @Test func testInitWithInvalidAPIURL() async {
        let invalidURL = "invalidurl"
        let mockBundle = MockBundle(infoDict: ["APIURL": invalidURL])

        let source = DataOfDaySource(bundle: mockBundle)
        let output = source.url
        #expect(output == nil)
    }

    @MainActor
    @Test func testInitWithNoAPIURL() async {
        let mockBundle = MockBundle(infoDict: [:])

        let source = DataOfDaySource(bundle: mockBundle)

        #expect(source.url == nil, "URL should be nil when APIURL is not present in Info.plist")
    }

    @MainActor
    @Test func testFetchDataWithValidURL() async throws {
        let validJSON = """
        {
            "data": [
                {
                    "attributes": {
                        "body": "Dogs wag their tails when they are happy."
                    }
                }
            ]
        }
        """
        let data = Data(validJSON.utf8)

        let url = URL(string: "https://example.com/api/data-of-day")!
        URLProtocolMock.mockResponse(for: url, data: data, statusCode: 200)

        let source = DataOfDaySource()
        source.url = url

        do {
            let content = try await source.fetchData()
            #expect(content == nil)
            if case .dogFact(let fact) = content {
                #expect(fact == "Dogs wag their tails when they are happy.")
            } else {
                #expect(content == nil, "Expected .dogFact but got \(String(describing: content))")
            }
        } catch {
            #expect(Bool(false), "fetchData threw an unexpected error: \(error)")
        }
    }

    @MainActor
    @Test func testFetchDataWithInvalidResponse() async throws {
        let invalidJSON = """
        {
            "unknown": "This key is not handled"
        }
        """
        let data = Data(invalidJSON.utf8)

        let url = URL(string: "https://example.com/api/data-of-day")!
        URLProtocolMock.mockResponse(for: url, data: data, statusCode: 200)

        let source = DataOfDaySource()
        source.url = url

        do {
            let content = try await source.fetchData()
            #expect(content == nil, "Content should be nil for invalid JSON response")
        } catch {
            #expect(Bool(false), "fetchData threw an unexpected error: \(error)")
        }
    }

    @MainActor
    @Test func testFetchDataWithNoURL() async {
        let source = DataOfDaySource()
        source.url = nil

        do {
            let data = try await source.fetchData()
            #expect(data == nil, "Expected .noURL error but no error was thrown")
        } catch DataOfDayError.noURL {
            // Test passed
        } catch {
            #expect(Bool(false), "Unexpected error thrown: \(error)")
        }
    }

    @MainActor
    @Test func testFetchWithURL() async {
        let workingURL = URL(string: "https://www.google.com")!
        let source = DataOfDaySource(url: workingURL)

        #expect(source.url != nil)

    }
}

// MARK: - Mock Helpers

extension MockBundle: @unchecked Sendable { }

final class MockBundle: Bundle {
    private let mockInfoDict: [String: Any]

    init(infoDict: [String: Any]) {
        self.mockInfoDict = infoDict
        super.init()
    }

    override func object(forInfoDictionaryKey key: String) -> Any? {
        return mockInfoDict[key]
    }
}

private class URLProtocolMock: URLProtocol {
    static var mockResponses: [URL: (data: Data?, statusCode: Int)] = [:]

    static func mockResponse(for url: URL, data: Data?, statusCode: Int) {
        mockResponses[url] = (data, statusCode)
    }

    override class func canInit(with request: URLRequest) -> Bool {
        return mockResponses.keys.contains(request.url!)
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let url = request.url,
              let response = URLProtocolMock.mockResponses[url] else {
            client?.urlProtocol(self, didFailWithError: URLError(.badURL))
            return
        }

        let httpResponse = HTTPURLResponse(
            url: url,
            statusCode: response.statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        client?.urlProtocol(self, didReceive: httpResponse, cacheStoragePolicy: .notAllowed)
        if let data = response.data {
            client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
