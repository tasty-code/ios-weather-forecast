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
    let list: [ForecastListDTO]
    let city: CityInformationDTO
}
