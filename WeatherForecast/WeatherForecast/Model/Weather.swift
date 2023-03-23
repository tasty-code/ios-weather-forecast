//
//  Weather.swift
//  WeatherForecast
//
//  Created by 이상윤 on 2023/03/15.
//

import Foundation

// MARK: - Weather
struct Weather: Decodable {
    let visibility, timeOfData, timezone, id, statusCode: Int
    let base, name: String
    let coordinate: Coordinate
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let clouds: Clouds
    let sys: Sys
    
    enum CodingKeys: String, CodingKey {
        case weather, base, main, visibility, wind, clouds, sys, timezone, id, name
        case coordinate = "coord"
        case timeOfData = "dt"
        case statusCode = "cod"
    }

    // MARK: - Clouds
    struct Clouds: Decodable {
        let cloudiness: Int
        
        enum CodingKeys: String, CodingKey {
            case cloudiness = "all"
        }
    }

    // MARK: - Coordinate
    struct Coordinate: Decodable {
        let latitude, longitude: Double
        
        enum CodingKeys: String, CodingKey {
            case latitude = "lat"
            case longitude = "lon"
        }
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

    // MARK: - Sys
    struct Sys: Decodable {
        let type, id, sunrise, sunset: Int
        let country: String
    }

    // MARK: - Weather
    struct Weather: Decodable {
        let main, description, icon: String
        let id: Int
    }

    // MARK: - Wind
    struct Wind: Decodable {
        let speed: Double
        let degree: Int
        
        enum CodingKeys: String, CodingKey {
            case speed
            case degree = "deg"
        }
    }
}
