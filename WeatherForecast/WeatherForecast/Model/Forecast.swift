//
//  Forecast.swift
//  WeatherForecast
//
//  Created by 신동오 on 2023/03/15.
//

import Foundation

// MARK: - Forecast
struct Forecast: Decodable {
    let list: [List]
    let city: City
    
    // MARK: - City
    struct City: Decodable {
        let name: String
        let coordinate: Coordinate
        
        enum CodingKeys: String, CodingKey {
            case name
            case coordinate = "coord"
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
    
    // MARK: - List
    struct List: Decodable {
        let timeOfData: Int
        let main: Main
        let weather: [Weather]
        let timeOfDataText: String
        
        enum CodingKeys: String, CodingKey {
            case main, weather
            case timeOfData = "dt"
            case timeOfDataText = "dt_txt"
        }
        
        // MARK: - Main
        struct Main: Decodable {
            let temp, feelsLike, tempMin, tempMax: Double
            
            enum CodingKeys: String, CodingKey {
                case temp
                case feelsLike = "feels_like"
                case tempMin = "temp_min"
                case tempMax = "temp_max"
            }
        }
        
        // MARK: - Weather
        struct Weather: Decodable {
            let main, description, icon: String
            let id: Int
        }
    }
}
