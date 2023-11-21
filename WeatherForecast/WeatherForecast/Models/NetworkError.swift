//
//  NetworkError.swift
//  WeatherForecast
//
//  Created by 김경록 on 11/21/23.
//

import Foundation

enum NetworkError: Error, CustomStringConvertible {
    case decodingError
    case responseError(statusCode: Int)
    case unknownError
    
    var description: String {
        switch self {
            
        case .decodingError:
            return "decodingError"
        case .responseError(statusCode: let statusCode):
            return "\(statusCode) responseError"
        case .unknownError:
            return "unknownError"
        }
    }
}
