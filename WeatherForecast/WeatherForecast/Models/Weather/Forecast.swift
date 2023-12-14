//
//  Forecast.swift
//  WeatherForecast
//
//  Created by 김경록 on 11/20/23.

import Foundation

// MARK: - Forecast

struct Forecast: Decodable {
    let city: City
    let list: [List]
}

// MARK: - City

struct City: Decodable {
    let coordinate: ForecastCoordinate
    let id: Int
    let name: String
    let country: String
    let population, timezone, sunrise, sunset: Int?
    
    enum CodingKeys: String, CodingKey {
        case id,name,country,population,timezone,sunrise,sunset
        case coordinate = "coord"
    }
}

// MARK: - List

struct List: Decodable, Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(timeOfDataForecasted)
    }
    
    static func == (lhs: List, rhs: List) -> Bool {
        return lhs.timeOfDataForecasted == rhs.timeOfDataForecasted
    }
    
    let weatherCondition: ForecastWeatherCondition
    let weather: [ForecastWeather]
    let clouds: ForecastClouds
    let wind: ForecastWind
    let rain: ForecastRain?
    let partOfDay: PartOfDay
    let visibility: Int
    let rainfallProbability: Double
    let timeOfDataForecasted: Int
    let timeOfDataForecastedTxt: String
    
    enum CodingKeys: String, CodingKey {
        case weather, clouds, wind, visibility, rain
        case timeOfDataForecasted = "dt"
        case timeOfDataForecastedTxt = "dt_txt"
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

// MARK: - ForecastWeather

struct ForecastWeather: Decodable {
    let id: Int
    let main, description, icon: String
}

// MARK: - ForecastWeatherCondition

struct ForecastWeatherCondition: Decodable {
    let temperature, feelsLike, minimumTemperature, maxTemperature: Double
    let pressure, humidity: Int
    let seaLevel, groundLevel: Int?
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLike = "feels_like"
        case minimumTemperature = "temp_min"
        case maxTemperature = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case groundLevel = "grnd_level"
    }
}

// MARK: - ForecastClouds

struct ForecastClouds: Decodable {
    let all: Int
}

// MARK: - ForecastWind

struct ForecastWind: Decodable {
    let speed: Double
    let degrees: Int
    let gust: Double?
    
    enum CodingKeys: String, CodingKey {
        case speed,gust
        case degrees = "deg"
    }
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
    let dayOrNight: String
    
    enum CodingKeys: String, CodingKey {
        case dayOrNight = "pod"
    }
}
