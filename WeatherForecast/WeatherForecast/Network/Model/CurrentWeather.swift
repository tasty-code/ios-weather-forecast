//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/14.
//

import Foundation

struct CurrentWeather: Codable {
    
    let mainData: MainData
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        
        case mainData = "main"
        case weather
    }
}

struct Coordinate: Codable {
    
    let longitude: Double
    let latitude: Double
}

extension Coordinate: CustomStringConvertible {
    
    var description: String {
        
        return "lat=\(latitude)&lon=\(longitude)"
    }
}

