//
//  ForecastListEntity.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/04/04.
//

import Foundation

struct ForecastListEntity {
    let dtTxt: String
    let main: TempEntity
    let weather: [WeatherInformationEntity]
}
