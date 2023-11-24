//
//  Errors.swift
//  WeatherForecast
//
//  Created by Wonji Ha on 2023/11/22.
//

import Foundation

enum APIKeyError : Error, CustomStringConvertible {
    case keyFileNotFound, keyNotFound
    
    var description: String {
        switch self {
        case .keyFileNotFound:
            return "키 파일을 찾을수 없습니다."
        case .keyNotFound:
            return "키를 찾을수 없습니다."
        }
    }
}

enum StatusCodeError: Error {
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case notAcceptable
    case other4XXError(statusCode: Int)
    case internalSeverError
    case badGateway
    case gatewayTimeout
    case other5XXError(statusCode: Int)
    case anotherStatusError(statusCode: Int)
    
    static func httpError(_ statusCode: Int) -> StatusCodeError {
        switch statusCode {
        case 400:
            return .badRequest
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 406:
            return .notAcceptable
        case 402, 405, 407..<500:
            return .other4XXError(statusCode: statusCode)
        case 500:
            return .internalSeverError
        case 502:
            return .badGateway
        case 504:
            return .gatewayTimeout
        case 501, 503, 505..<600:
            return .other5XXError(statusCode: statusCode)
        default:
            return .anotherStatusError(statusCode: statusCode)
        }
    }
}

