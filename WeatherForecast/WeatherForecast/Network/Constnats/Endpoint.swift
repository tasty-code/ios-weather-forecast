//
//  Endpoint.swift
//  WeatherForecast
//
//  Created by Janine on 11/20/23.
//

import Foundation

enum Endpoint: String, CaseIterable, Decodable {
    case weather
    case forecast
    case icon
}

extension Endpoint {
    var baseUrl: String {
        switch self {
        case .weather, .forecast:
            return Environment.baseURL
        case .icon:
            return Environment.imageBaseURL
        }
    }
    
    var endpoint: String {
        switch self {
        case .weather, .forecast:
            return self.rawValue
        case .icon:
            return ""
        }
    }
}

