//
//  URLParameterEncoder.swift
//  EfektaMobile
//
//  Created by Adriana Elizondo on 2018/11/8.
//  Copyright © 2018 EF. All rights reserved.
//
import Foundation
public struct URLParameterEncoder: ParameterEncoder {
     static func encode(urlRequest: inout URLRequest, with urlParameters: Parameters) throws {
        guard let url = urlRequest.url else { throw NetworkError.invalidUrl }
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !urlParameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            for (key, value) in urlParameters {
                guard !key.isEmpty else {
            urlRequest.url?.appendPathComponent("\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")
                    return
                }
                let queryItem = URLQueryItem(name: key,
                                             value:
                    "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}
