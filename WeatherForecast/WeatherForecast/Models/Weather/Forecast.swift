//
//  Forecast.swift
//  WeatherForecast
//
//  Created by 김경록 on 11/20/23.

import Foundation

// MARK: - Forecast

struct Forecast: Decodable {
    let list: [List]
    let city: City
}

// MARK: - City

struct City: Decodable {
    let id: Int
    let name: String
    let coord: ForecastCoordinate
    let country: String
    let population, timezone, sunrise, sunset: Int?
}

// MARK: - List

struct List: Decodable {
    let dt: Int
    let weatherCondition: ForecastWeatherCondition
    let weather: [ForecastWeather]
    let clouds: ForecastClouds
    let wind: ForecastWind
    let visibility: Int
    let rainfallProbability: Double
    let rain: ForecastRain?
    let partOfDay: PartOfDay
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
        case dt, weather, clouds, wind, visibility, rain
        case dtTxt = "dt_txt"
        case partOfDay = "sys"
        case weatherCondition = "main"
        case rainfallProbability = "pop"
    }
}

// MARK: - ForecastCoordinate

struct ForecastCoordinate: Decodable {
    let longitude, latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}

// MARK: - ForecastWeatherCondition

struct ForecastWeatherCondition: Decodable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int
    let seaLevel, grndLevel: Int?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - ForecastWeather

struct ForecastWeather: Decodable {
    let id: Int
    let main, description, icon: String
}

// MARK: - ForecastClouds

struct ForecastClouds: Decodable {
    let all: Int
}

// MARK: - ForecastWind

struct ForecastWind: Decodable {
    let speed: Double
    let deg: Int
    let gust: Double?
}

// MARK: - ForecastRain

struct ForecastRain: Decodable {
    let amountOfRainOneHour: Double?
    let amountOfRainThreeHour: Double?
    
    enum CodingKeys: String, CodingKey {
        case amountOfRainOneHour = "1h"
        case amountOfRainThreeHour = "3h"
    }
}

// MARK: - PartOfDay

struct PartOfDay: Decodable {
    let pod: String
}
