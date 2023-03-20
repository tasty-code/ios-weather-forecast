//
//  NetworkError.swift
//  WeatherForecast
//
//  Created by Mason Kim on 2023/03/14.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidData
    case networking
    case parse
    case response

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL이 잘못되었습니다."
        case .invalidData:
            return "Data 형식이 잘못되었습니다."
        case .networking:
            return "네트워킹에 실패했습니다."
        case .parse:
            return "데이터를 파싱하는데 실패했습니다."
        case .response:
            return "응답코드가 정상코드가 아닙니다."
        }
    }
}
