//
//  NetworkError.swift
//  WeatherForecast
//
//  Created by 김예준 on 11/24/23.
//

import Foundation

enum NetworkError: Error, CustomStringConvertible {
    case invailedURL
    
    var description: String {
        switch self {
        case .invailedURL:
            "API url이 유효하지 않습니다."
        }
    }
}
