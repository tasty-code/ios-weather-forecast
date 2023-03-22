//
//  NetworkError.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/03/22.
//

import Foundation

enum NetworkError: String, Error {
    case networkError = "네트워크 오류입니다"
    case dataError = "데이터 오류입니다"
    case parseError = "파싱 오류입니다"
}
