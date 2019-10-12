//
//  Extensions.swift
//  NetworkLayer
//
//  Created by Adriana Elizondo on 2019/10/11.
//  Copyright © 2019 EF. All rights reserved.
//

import Foundation

extension URLSession: URLSessionProtocol {
    public func routerDataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTaskProtocol
    }
}
extension URLSessionDataTask: URLSessionDataTaskProtocol {}
