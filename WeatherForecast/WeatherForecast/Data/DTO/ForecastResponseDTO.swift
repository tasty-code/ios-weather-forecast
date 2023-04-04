//
//  ForecastResponseDTO.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/03/30.
//

import Foundation

struct ForecastResponseDTO: Decodable {
    let cod: String
    let message, cnt: Int
    let list: [ListDTO]
    let city: CityDTO
}

struct CityDTO: Decodable {
    let name, country: String
    let id, population, timezone, sunrise, sunset: Int
    let coord: CoordDTO
}

struct ListDTO: Decodable {
    let dt, visibility: Int
    let pop: Double
    let dtTxt: String
    let main: MainDTO
    let weather: [WeatherElementDTO]
    let clouds: CloudsDTO
    let wind: WindDTO
    let rain: ForecastRain?
    let sys: ForecastSys
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, rain, sys
        case dtTxt = "dt_txt"
    }
}

struct ForecastRain: Decodable {
    let the3H: Double
    
    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

struct ForecastSys: Decodable {
    let pod: String
}
