//
//  CommonWeatherComponents.swift
//  WeatherForecast
//
//  Created by J.E on 2023/03/14.
//

import Foundation

struct Coordinate: Decodable {
    let longitude, latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}

struct Weather: Decodable {
    let id: Int
    let main, description, icon: String
}

struct NumericalWeatherInformation: Decodable {
    let temperature, feelsLike, minimumTemperature, maximumTemperature: Double
    let pressure, humidity: Int
    let seaLevel, grandLevel: Int?

    enum CodingKeys: String, CodingKey {
        case feelsLike = "feels_like"
        case minimumTemperature = "temp_min"
        case maximumTemperature = "temp_max"
        case seaLevel = "sea_level"
        case grandLevel = "grnd_level"
        case temperature, pressure, humidity
    }
}

struct Wind: Decodable {
    let speed: Double
    let degree: Int
    let gust: Double?
}

struct Clouds: Decodable {
    let cloudiness: Int
}

struct System: Decodable {
    let country: String?
    let sunrise, sunset: Int?
    let partOfTheDay: DayPart?
}

enum DayPart: String, Decodable {
    case day = "d"
    case night = "n"
}
