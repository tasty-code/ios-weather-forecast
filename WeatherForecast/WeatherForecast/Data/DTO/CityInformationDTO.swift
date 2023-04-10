//
//  CityInformationDTO.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/04/04.
//

import Foundation

struct CityInformationDTO: Decodable {
    let name, country: String
    let id, population, timezone, sunrise, sunset: Int
    let coord: CoordinateDTO
}
