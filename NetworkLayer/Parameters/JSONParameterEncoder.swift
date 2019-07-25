//
//  JSONParameterEncoder.swift
//  EfektaMobile
//
//  Created by Adriana Elizondo on 2018/11/8.
//  Copyright © 2018 EF. All rights reserved.
//

import Foundation

public struct JSONParameterEncoder: ParameterEncoder{
    static func encode<T: Encodable>(urlRequest: inout URLRequest, with parameters: T) throws {
        let jsonData = try JSONEncoder().encode(parameters)
        urlRequest.httpBody = jsonData
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil{
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
    }
}
