//
//  NetworkError.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/16.
//

import UIKit

typealias NetworkResult = Result<String, NetworkError>

enum NetworkError: Error {
    case outOfReponseCode
    case failedRequest
    
    var message: String {
        switch self {
        case .outOfReponseCode:
            return "응답코드가 정상코드 범위에 없습니다."
        case .failedRequest:
            return "잘못된 요청입니다."
        }
    }
}

extension NetworkError {
    func resultOfNetworkError() -> NetworkResult {
        return .failure(self)
    }
}
