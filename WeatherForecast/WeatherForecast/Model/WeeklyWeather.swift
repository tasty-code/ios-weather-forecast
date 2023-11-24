//
//  WeeklyWeather.swift
//  WeatherForecast
//
//  Created by 김수경 on 2023/11/20.
//

import Foundation

struct WeeklyWeather: Decodable {
    var cod: String?
    var message: Int?
    var timestampCount: Int?
    var list: [List]?
    var city: City?
    
    enum CodingKeys:String, CodingKey {
        case cod, message, list, city
        case timestampCount = "cnt"
    }
}

// MARK: - List

struct List: Decodable {
    var dataTime: Int?
    var main: Main?
    var weather: [Weather]?
    var clouds: Clouds?
    var wind: Wind?
    var visibility: Int?
    var probabilityOfPrecipitation: Double?
    var rain: Rain?
    var snow: Snow?
    var system: System?
    var dateText: String?
    
    struct System: Decodable {
        var partOfTheDay: String?
        
        enum CodingKeys:String, CodingKey {
            case partOfTheDay = "pod"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case main, weather, clouds, wind, visibility, rain, snow
        case dataTime = "dt"
        case probabilityOfPrecipitation = "pop"
        case system = "sys"
        case dateText = "dt_txt"
    }
}

// MARK: - City

struct City: Decodable {
    var id: Int?
    var name: String?
    var coordinate: Coordinate?
    var country: String?
    var population: Int?
    var timezone: Int?
    var sunrise: Int?
    var sunset: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name, country, population, timezone, sunrise, sunset
        case coordinate = "coord"
    }
}


