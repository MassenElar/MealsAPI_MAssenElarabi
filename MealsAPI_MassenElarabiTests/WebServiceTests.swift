//
//  MealsAPI_MassenElarabiTests.swift
//  MealsAPI_MassenElarabiTests
//
//  Created by Massen Elarabi on 7/9/24.
//

import XCTest
@testable import MealsAPI_MassenElarabi

class WebServiceTests: XCTestCase {
    
    var sut: MealsWebService!
    var mockSuccessResponse: HTTPURLResponse!
    var mockFailResponse: HTTPURLResponse!
    let mockURL: String = "https://jsonplaceholder.test.com"
    let mockResponseData = """
        {
            "mockString": "abc",
            "mockInt": 123
        }
    """.data(using: .utf8)!
    let expectedResponseData = MockResponseDataType(mockString: "abc", mockInt: 123)
    let expectedErrorDescription = "Unexpected HTTP status code: 400"

    override func setUpWithError() throws {
        mockSuccessResponse = HTTPURLResponse.build(url: mockURL, statusCode: 200)
        mockFailResponse = HTTPURLResponse.build(url: mockURL, statusCode: 400)
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        let urlSession = URLSession(configuration: configuration)
        sut = MealsWebService(urlSession: urlSession)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testSuccessResponse() async {
        do {
            let requestHandler = RequestHandler(url: URL(string: mockURL)!,
                                                response: [mockSuccessResponse],
                                                data: mockResponseData)
            URLProtocolMock.requestHandler = requestHandler.handleRequest
            let url = URL(string: mockURL)!
            let response: MockResponseDataType = try await sut.callAPI(url: url)
            XCTAssertNotNil(response)
            XCTAssertEqual(response.mockInt, 123)
            XCTAssertEqual(response.mockString, "abc")
        } catch(let error) {
            XCTFail("Async testReceivingSuccessfulResponse error: \(error)")
        }
    }
    
    func testFailedResponse() async {
        do {
            let invalidResponseData = """
                {
                    "error": {
                        "message": "Some Generic Error Description",
                        "type": "SOME_KNOWN_ERROR_TYPE_CODE"
                    }
                }
            """.data(using: .utf8)!
            let requestHandler = RequestHandler(url: URL(string: mockURL)!,
                                                response: [mockFailResponse],
                                                data: invalidResponseData)
            URLProtocolMock.requestHandler = requestHandler.handleRequest
            let url = URL(string: mockURL)!
            let _: MockResponseDataType = try await sut.callAPI(url: url)
        } catch (let error) {
            let apiError = error as? APIError
            var actualStatusCode: Int?
            switch apiError {
            case .httpStatusCode(let code):
                actualStatusCode = code
            default:
                break
            }
            XCTAssertEqual(error.localizedDescription, expectedErrorDescription)
            XCTAssertEqual(actualStatusCode, 400)
        }
    }
}

// MARK: - MockResponseDataType for testing API requests
struct MockResponseDataType: Decodable, Equatable {
    
    let mockString: String
    let mockInt: Int
}

// MARK: - mock url protocol
class URLProtocolMock: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canInit(with task: URLSessionTask) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        guard let requestHandler = Self.requestHandler else {
            XCTFail("Received unexpected request with no handler set")
            return
        }
        do {
            let (response, data) = try requestHandler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
    }
}

// MARK: - build mock responses
extension HTTPURLResponse {
    static func build(url: String = "https://jsonplaceholder.test.com",
                      statusCode: Int = 200) -> HTTPURLResponse {
        let urlSt = URL(string: url)!
        return HTTPURLResponse(url: urlSt,
                               statusCode: statusCode,
                               httpVersion: nil,
                               headerFields: nil)!
    }
}

// MARK: - request handler
class RequestHandler {
    var allRequests: [URLRequest] = []
    var receivedHeaderFields: [String: String]?
    
    let url: URL
    var response: [HTTPURLResponse]
    let data: Data
    init(url: URL, response: [HTTPURLResponse], data: Data) {
        self.url = url
        self.response = response
        self.data = data
    }
    
    func handleRequest(_ request: URLRequest) throws -> (HTTPURLResponse, Data) {
        self.receivedHeaderFields = request.allHTTPHeaderFields
        self.allRequests.append(request)
        let finalResponse = response.first!
        response.remove(at: 0)
        return (finalResponse, data)
    }
}



