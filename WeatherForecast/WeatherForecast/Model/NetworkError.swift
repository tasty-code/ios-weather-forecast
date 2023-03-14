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
    case networkingError
    case parseError
    case responseError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL이 잘못되었습니다."
        case .invalidData:
            return "Data 형식이 잘못되었습니다."
        case .networkingError:
            return "네트워킹에 실패했습니다."
        case .parseError:
            return "데이터를 파싱하는데 실패했습니다."
        case .responseError:
            return "응답코드가 정상코드가 아닙니다."
        }
    }
}
