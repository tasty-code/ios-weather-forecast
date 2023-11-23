//
//  NetworkError.swift
//  WeatherForecast
//
//  Created by 김경록 on 11/21/23.
//

import Foundation

enum NetworkError: Error, CustomStringConvertible {
    case invalidURLError
    case unknownError(_ error: Error)
    case responseError(statusCode: Int)
    case noDataError
    case decodingError
    
    var description: String {
        switch self {
        case .invalidURLError:
            return "API_KEY가 유효하지 않습니다!!"
        case .unknownError(error: let error):
            return "알 수 없는 에러입니다!! \(error.localizedDescription)"
        case .responseError(statusCode: let statusCode):
            return "응답 코드를 확인해주세요!! \(statusCode)"
        case .noDataError:
            return "데이터가 없습니다!!"
        case .decodingError:
            return "디코딩이 되지 않았습니다!!"
        }
    }
}
