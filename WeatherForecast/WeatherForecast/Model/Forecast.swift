//
//  Forecast.swift
//  WeatherForecast
//
//  Created by 신동오 on 2023/03/15.
//

import Foundation

// MARK: - Forecast
struct Forecast: Decodable {
    let statusCode: String
    let statusMessage, numberOfTimeStamps: Int
    let list: [List]
    let city: City
    
    enum CodingKeys: String, CodingKey {
        case list, city
        case statusCode = "cod"
        case statusMessage = "message"
        case numberOfTimeStamps = "cnt"
    }
    
    // MARK: - City
    struct City: Decodable {
        let id: Int
        let name: String
        let coordinate: Coordinate
        let country: String
        let population, timezone, sunrise, sunset: Int
        
        enum CodingKeys: String, CodingKey {
            case id, name, country, population, timezone, sunrise, sunset
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
        let clouds: Clouds
        let wind: Wind
        let visibility: Int
        let pop: Double
        let sys: Sys
        let timeOfDataText: String
        let rain: Rain?
        
        enum CodingKeys: String, CodingKey {
            case main, weather, clouds, wind, visibility, pop, sys, rain
            case timeOfData = "dt"
            case timeOfDataText = "dt_txt"
        }
        
        // MARK: - Clouds
        struct Clouds: Decodable {
            let cloudiness: Int
            
            enum CodingKeys: String, CodingKey {
                case cloudiness = "all"
            }
        }
        
        // MARK: - Main
        struct Main: Decodable {
            let temp, feelsLike, tempMin, tempMax: Double
            let pressure, seaLevel, grndLevel, humidity: Int
            let tempKf: Double
            
            enum CodingKeys: String, CodingKey {
                case temp, pressure, humidity
                case feelsLike = "feels_like"
                case tempMin = "temp_min"
                case tempMax = "temp_max"
                case seaLevel = "sea_level"
                case grndLevel = "grnd_level"
                case tempKf = "temp_kf"
            }
        }
        
        // MARK: - Rain
        struct Rain: Decodable {
            let the3H: Double
            
            enum CodingKeys: String, CodingKey {
                case the3H = "3h"
            }
        }
        
        // MARK: - Sys
        struct Sys: Decodable {
            let pod: Pod
        }
        
        enum Pod: String, Decodable {
            case day = "d"
            case night = "n"
        }
        
        // MARK: - Weather
        struct Weather: Decodable {
            let id: Int
            let main: MainEnum
            let description: Description
            let icon: String
        }
        
        enum Description: String, Decodable {
            case brokenClouds = "broken clouds"
            case clearSky = "clear sky"
            case fewClouds = "few clouds"
            case lightRain = "light rain"
            case overcastClouds = "overcast clouds"
            case scatteredClouds = "scattered clouds"
        }
        
        enum MainEnum: String, Decodable {
            case clear = "Clear"
            case clouds = "Clouds"
            case rain = "Rain"
        }
        
        // MARK: - Wind
        struct Wind: Decodable {
            let speed: Double
            let degree: Int
            let gust: Double
            
            enum CodingKeys: String, CodingKey {
                case speed, gust
                case degree = "deg"
            }
        }
    }
}
