//
//  QueryError.swift
//  WeatherForecast
//
//  Created by 김수경 on 2023/12/01.
//

import Foundation

enum QueryError: Error, CustomStringConvertible {
    case noneCoordinate
    case noneAPIKey

    var description: String {
        switch self {
        case .noneCoordinate:
            return "좌표 정보가 없습니다."
        case .noneAPIKey:
            return "APIKey 정보가 없습니다."
        }
    }
}
