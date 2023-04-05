//
//  LocationError.swift
//  WeatherForecast
//
//  Created by 신동오 on 2023/03/27.
//

import Foundation

enum LocationError: LocalizedError {
    case emptyLocation
    
    var errorDescription: String? {
        switch self {
        case .emptyLocation: return "Location이 없습니다."
        }
    }
}
