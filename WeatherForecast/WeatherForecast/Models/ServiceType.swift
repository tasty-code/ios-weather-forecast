//
//  File.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/20/23.
//

import Foundation

enum ServiceType {
    case weather, forecast
    
    var name: String {
        switch self {
        case .weather: "weather"
        case .forecast: "forecast"
        }
    }
    
    var decodingType: Decodable.Type {
        switch self {
        case .weather: WeatherModel.self
        case .forecast: ForecastModel.self
        }
    }
}
