//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/14.
//

import Foundation

struct CurrentWeather: Codable {
    
    let coordinate: Coordinate
    let weatherData: WeatherData
    
    enum CodingKeys: String, CodingKey {
        
        case coordinate = "coord"
        case weatherData = "main"
    }
}

struct Coordinate: Codable {
    
    let longitude: Double
    let latitude: Double
    
    enum CodingKeys: String, CodingKey {
        
        case longitude = "lon"
        case latitude = "lat"
    }
}

extension Coordinate: CustomStringConvertible {
    
    var description: String {
        
        return "lat=\(latitude)&lon=\(longitude)"
    }
}

