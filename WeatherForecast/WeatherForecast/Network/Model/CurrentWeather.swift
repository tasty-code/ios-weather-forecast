//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/14.
//

import Foundation

struct CurrentWeather: Codable {
    let coordinate: Coordinate
    let weather: [WeatherData]
    
    enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case weather
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

struct WeatherData: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
