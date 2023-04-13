//
//  Weather.swift
//  WeatherForecast
//
//  Created by 이상윤 on 2023/03/15.
//

import Foundation

// MARK: - Weather
struct Weather: Decodable {
    let timeOfData, timezone: Int
    let name: String
    let coordinate: Coordinate
    let weather: [Weather]
    let main: Main

    enum CodingKeys: String, CodingKey {
        case weather, main, timezone, name
        case coordinate = "coord"
        case timeOfData = "dt"
    }

    // MARK: - Coordinate
    struct Coordinate: Decodable {
        let latitude, longitude: Double
        
        enum CodingKeys: String, CodingKey {
            case latitude = "lat"
            case longitude = "lon"
        }
    }

    // MARK: - Weather
    struct Weather: Decodable {
        let main, description, icon: String
        let id: Int
    }

    // MARK: - Main
    struct Main: Decodable {
        let temp, feelsLike, tempMin, tempMax: Double
        let pressure, humidity: Int

        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure, humidity
        }
    }
}
