//
//  BaseResponseCodable.swift
//  EfektaMobile
//
//  Created by Adriana Elizondo on 2018/11/8.
//  Copyright © 2018 EF. All rights reserved.
//

import Foundation
public enum NetworkResponseError: Error {
    case error(errorData: ErrorMetaData)
    case parsingError(error: Error?)
    case requestFailed(error: Error?)
    case badRequest(error: Error?)
    case forbidden(error: Error?)
    case serverError(error: Error?)
    case redirected(error: Error?)
    case migration(error: Error?)
}

public enum ResponseErrors: Int {
    case migration = 111
    case unknown = 999
}

public protocol ErrorHandler {
    var errorCode: Int? { get }
    var errorDescription: String? { get }
    var errorMetaData: ErrorMetaData? { get }
    var lastUpdate: Double? { get }
}

public typealias ServiceResponseCodable = Codable & ErrorHandler

public protocol ServiceResponseProtocol: Codable {
    func getServiceResponse() -> ServiceResponseCodable
}

public struct ErrorMetaData: Codable {
    var startupTitle: String?
    var startupMessage: String?
}
