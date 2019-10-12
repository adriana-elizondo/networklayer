//
//  EndpointType.swift
//  EfektaMobile
//
//  Created by Adriana Elizondo on 2018/11/8.
//  Copyright © 2018 EF. All rights reserved.
//

import Foundation
import UIKit

public typealias HTTPHeaders = [String: String]
public typealias Parameters = [String: Any]
public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}
public enum HttpTask<T: Encodable> {
    case request
    case requestWithParameters(bodyParameters: T? , queryParameters: Parameters?, pathParameters: [String]?)
}
public protocol EndpointType: RouterCompletionDelegate {
    associatedtype ParameterType: Encodable
    var baseUrl: URL { get }
    var path: String { get }
    var httpMethod: HttpMethod { get }
    var task: HttpTask<ParameterType> { get }
    var headers: HTTPHeaders? { get }
}
public extension EndpointType {
    var headers: HTTPHeaders? {
        return nil
    }
    func didFinishWithSuccess() {
        //nada
    }
    func didFinishWithError() {
        //nada
    }
}
