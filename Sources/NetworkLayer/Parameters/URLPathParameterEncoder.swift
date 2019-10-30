//
//  URLPathParameterEncoder.swift
//  NetworkLayer
//
//  Created by Adriana Elizondo on 2019/9/10.
//  Copyright © 2019 EF. All rights reserved.
//

import Foundation

public struct URLPathParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with pathParameters: [String]) throws {
        guard urlRequest.url != nil else { throw NetworkError.invalidUrl }
        for parameter in pathParameters {
            urlRequest.url?.appendPathComponent(parameter)
        }
    }
}
