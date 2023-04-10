//
//  WeatherNetworkError.swift
//  WeatherForecast
//
//  Created by Blu on 2023/03/14.
//

import Foundation

enum WeatherNetworkError: Error {
    case invalidURL
    case requestFailed(String)

    var description: String {
        switch self {
        case .invalidURL:
            return "유효하지 않은 URL입니다."
        case .requestFailed(let dataType):
            return "\(dataType) 요청에 실패했습니다."
        }
    }
}
