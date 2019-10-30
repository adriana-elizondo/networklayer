//
//  ParameterEncoding.swift
//  EfektaMobile
//
//  Created by Adriana Elizondo on 2018/11/8.
//  Copyright © 2018 EF. All rights reserved.
//

import Foundation

public enum NetworkError: String, Error {
    case invalidParameters = "Parameters were nil"
    case encodingFailed = "Encoding failed"
    case invalidUrl = "Invalid url"
}
public protocol ParameterEncoder {
    func encode<T: Encodable>(urlRequest: inout URLRequest, with parameters: T) throws
    func encode(urlRequest: inout URLRequest, with urlParameters: Parameters) throws
}
public extension ParameterEncoder {
    //Optional
    func encode(urlRequest: inout URLRequest, with urlParameters: Parameters) throws {}
    func encode<T: Encodable>(urlRequest: inout URLRequest, with parameters: T) throws {}
}
