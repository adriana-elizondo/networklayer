//
//  NetworkLayerTestsTests.swift
//  NetworkLayerTestsTests
//
//  Created by Adriana Elizondo on 2019/10/11.
//  Copyright © 2019 adriana. All rights reserved.
//

import XCTest
@testable import NetworkLayer
class MockParameters: Encodable {}
class MockEndpoint: EndpointType {
    var baseUrl: URL { return URL(string: "mockurl")! }
    var path: String { return "mockpath" }
    var httpMethod: HttpMethod { return .get }
    var task: HttpTask<MockParameters> { return HttpTask.request }
    typealias ParameterType = MockParameters
}
class MockEndpointGetWithNoParameters: MockEndpoint {
    override var task: HttpTask<MockParameters> { return HttpTask.request }
    typealias ParameterType = MockParameters
}
class MockEndpointGetWithParameters: MockEndpoint {
    var mockGetPatameters: Parameters {
        return ["MockParameter" : "MockValue"]
    }
    override var task: HttpTask<MockParameters> { return HttpTask.requestWithParameters(bodyParameters: nil,
                                        queryParameters: mockGetPatameters,
                                        pathParameters: nil) }
    typealias ParameterType = MockParameters
}
class MockEndpointWithExtendedPath: MockEndpoint {
    override var task: HttpTask<MockParameters> { return HttpTask.request }
    typealias ParameterType = MockParameters
    override var path: String {
        return "/this/is/a/test"
    }
}
class MockEndpointPostWithNoParameters: MockEndpoint {
    override var task: HttpTask<MockParameters> { return HttpTask.request }
    override var httpMethod: HttpMethod {
        return .post
    }
    override var path: String {
        return ""
    }
    typealias ParameterType = MockParameters
}
class MockResponseObject: Codable {
    let mockName = "Mock name"
}
class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var wasResumeCalled = false
    func resume() {
        wasResumeCalled = true
    }
    func cancel() {
        //
    }
}
class MockURLSession: URLSessionProtocol {
    var nextDataTask = MockURLSessionDataTask()
    private (set) var lastURL: URL?
    func routerDataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURL = request.url
        do {
           let data =  try JSONEncoder().encode(MockResponseObject())
            //if the url response is nil in the router the request will be marked as failed
            completionHandler(data, HTTPURLResponse(), nil)
        } catch let error {
            print(error)
        }
        return nextDataTask
    }
}
class NetworkLayerTests: XCTestCase {
    let session = MockURLSession()
    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testGetRequestWithoutParameters() {
        let router: Router<MockEndpointGetWithNoParameters, MockResponseObject>? = Router(session: session)
        router?.request(with: MockEndpointGetWithNoParameters(),
                        completion: { (mockresponse, urlresponse, error) in
            XCTAssertEqual(self.session.lastURL?.absoluteString,
                           "\(MockEndpoint().baseUrl)/\(MockEndpoint().path)")
            XCTAssertNotNil(mockresponse, "Response should not be nil - \(String(describing: mockresponse))")
            XCTAssertNil(error)
        })
        XCTAssertTrue(session.nextDataTask.wasResumeCalled)
    }
    func testGetRequestWithParameters() {
        let router: Router<MockEndpointGetWithParameters, MockResponseObject>? = Router(session: session)
                let endpoint = MockEndpointGetWithParameters()
                router?.request(with: endpoint,
                                completion: { (mockresponse, urlresponse, error) in
                    XCTAssertEqual(self.session.lastURL?.absoluteString,
                                   "\(MockEndpoint().baseUrl)/\(endpoint.path)?\(endpoint.mockGetPatameters.keys.first!)=\(endpoint.mockGetPatameters.values.first!)")
                    XCTAssertNotNil(mockresponse, "Response should not be nil - \(String(describing: mockresponse))")
                    XCTAssertNil(error)
                })
                XCTAssertTrue(session.nextDataTask.wasResumeCalled)
    }
    func testGetRequestWithExtendedPath() {
        let router: Router<MockEndpointWithExtendedPath, MockResponseObject>? = Router(session: session)
                        let endpoint = MockEndpointWithExtendedPath()
                        router?.request(with: endpoint,
                                        completion: { (mockresponse, urlresponse, error) in
                            XCTAssertEqual(self.session.lastURL?.absoluteString,
                                           "\(MockEndpoint().baseUrl)\(endpoint.path)")
                            XCTAssertNotNil(mockresponse, "Response should not be nil - \(String(describing: mockresponse))")
                            XCTAssertNil(error)
                        })
                        XCTAssertTrue(session.nextDataTask.wasResumeCalled)
    }
    func testPostRequestWithoutParameters() {
        let router: Router<MockEndpointPostWithNoParameters, MockResponseObject>? = Router(session: session)
                               let endpoint = MockEndpointPostWithNoParameters()
                               router?.request(with: endpoint,
                                               completion: { (mockresponse, urlresponse, error) in
                                   XCTAssertEqual(self.session.lastURL?.absoluteString,
                                                  "\(MockEndpoint().baseUrl)/")
                                   XCTAssertNotNil(mockresponse, "Response should not be nil - \(String(describing: mockresponse))")
                                   XCTAssertNil(error)
                               })
                               XCTAssertTrue(session.nextDataTask.wasResumeCalled)
    }
}

