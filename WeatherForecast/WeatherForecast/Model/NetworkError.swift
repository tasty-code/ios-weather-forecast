//
//  NetworkError.swift
//  WeatherForecast
//
//  Created by 김수경 on 2023/11/22.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case urlFormattingError
    case responseError(statusCode: Int)
    case emptyDataError
    case decodingError
    
    var errorDescription: String {
        switch self {
        case .urlFormattingError:
            return "url 변환 실패"
        case .responseError(let statusCode):
            return "Response Error: \(statusCode)"
        case .emptyDataError:
            return "데이터 없음"
        case .decodingError:
            return "디코딩 에러"
        }
    }
}
