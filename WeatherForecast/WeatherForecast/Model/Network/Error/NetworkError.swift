//
//  NetworkError.swift
//  WeatherForecast
//
//  Created by 신동오 on 2023/03/23.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case apiFilePath
    case apiResource
    case apiKey
    case decodeError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "invalid URL"
        case .apiKey: return "api key 에러"
        case .apiResource: return "api resource 에러"
        case .apiFilePath: return "api file path 에러"
        case .decodeError: return "decode 에러가 발생했습니다."
        }
    }
}
