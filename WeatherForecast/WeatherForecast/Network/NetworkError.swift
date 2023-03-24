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
    case unknownError
    case invalidHttpStatusCode(Int)
    case components
    case urlRequest(Error)
    case parsing(Error)
    case emptyData
    case decodeError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "invalid URL"
        case .apiKey: return "api key 에러"
        case .apiResource: return "api resource 에러"
        case .apiFilePath: return "api file path 에러"
        case .unknownError: return "알수 없는 에러입니다."
        case .invalidHttpStatusCode: return "status코드가 200~299가 아닙니다."
        case .components: return "components를 생성 에러가 발생했습니다."
        case .urlRequest: return "URL request 관련 에러가 발생했습니다."
        case .parsing: return "데이터 parsing 중에 에러가 발생했습니다."
        case .emptyData: return "data가 비어있습니다."
        case .decodeError: return "decode 에러가 발생했습니다."
        }
    }
}
