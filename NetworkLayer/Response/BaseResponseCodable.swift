//
//  BaseResponseCodable.swift
//  EfektaMobile
//
//  Created by Adriana Elizondo on 2018/11/8.
//  Copyright © 2018 EF. All rights reserved.
//

import Foundation
public enum NetworkResponseError: Error{
    case Error(errorData: ErrorMetaData)
    case ParsingError
    case RequestFailed
    case BadRequest
    case Forbidden
    case ServerError
    case Redirected
    case Migration
}

public enum ResponseErrors: Int{
    case Migration = 111
    case Unknown = 999
}

public protocol ErrorHandler{
    var errorCode: Int? { get }
    var errorDescription : String? { get }
    var errorMetaData: ErrorMetaData? { get }
    var lastUpdate: Double? { get }
}

public typealias ServiceResponseCodable = Codable & ErrorHandler

public protocol ServiceResponseProtocol: Codable{
    func getServiceResponse() -> ServiceResponseCodable
}

public struct ErrorMetaData: Codable{
    var startupTitle: String?
    var startupMessage: String?
}

