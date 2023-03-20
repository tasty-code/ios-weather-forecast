//
//  NetworkingError.swift
//  WeatherForecast
//
//  Created by Bora Yang on 2023/03/20.
//

import Foundation

enum NetworkingError: Error {
    case networkError
    case dataError
    case parseError
}

extension NetworkingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .networkError:
            return "네트워크 오류입니다"
        case . dataError:
            return "데이터 오류입니다"
        case .parseError:
            return "파싱 오류입니다"
        }
    }
}
