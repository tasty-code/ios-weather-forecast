//
//  Weather.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/20/23.
//

import Foundation

/*
 https://api.openweathermap.org/data/2.5/"\(forecast)"?lat="\(latitude)&lon="\(longitude)"&appid="\(api_key)"&units=metric&lang=kr
 */

struct WeatherModel: Codable {
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
}

extension WeatherModel {
    struct Clouds: Codable {
        let all: Int?
    }
}

extension WeatherModel {
    struct Coord: Codable {
        let lon, lat: Double?
    }
}

extension WeatherModel {
    struct Main: Codable {
        let temp, feelsLike, tempMin, tempMax: Double?
        let pressure, humidity: Int?
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure, humidity
        }
    }
}

extension WeatherModel {
    struct Sys: Codable {
        let type, id: Int?
        let country: String?
        let sunrise, sunset: Int?
    }
}

extension WeatherModel {
    struct Weather: Codable {
        let id: Int?
        let main, description, icon: String?
        
    }
}

extension WeatherModel {
    struct Wind: Codable {
        let speed: Double?
        let deg: Int?
    }
}
