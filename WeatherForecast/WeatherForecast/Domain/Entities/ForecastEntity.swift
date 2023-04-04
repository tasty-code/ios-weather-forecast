//
//  ForecastEntity.swift
//  WeatherForecast
//
//  Created by Bora Yang on 2023/03/14.
//

import Foundation

struct ForecastEntity {
    let list: [ListEntity]
    let city: CityEntity
}

struct CityEntity {
    let name, country: String
}

struct ListEntity {
    let dtTxt: String
    let main: MainForecastEntity
    let weather: [FiveDaysWeatherElementEntity]
}

struct MainForecastEntity {
    let temp: Double?
}

struct FiveDaysWeatherElementEntity {
    let id: Int?
    let main, description, icon: String?
}
