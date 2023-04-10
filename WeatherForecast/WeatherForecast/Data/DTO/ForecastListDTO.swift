//
//  ForecastListDTO.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/04/04.
//

import Foundation

struct ForecastListDTO: Decodable {
    let dt, visibility: Int
    let pop: Double
    let dtTxt: String
    let main: TemperatureInformationDTO
    let weather: [WeatherInformationDTO]
    let clouds: CloudsDTO
    let wind: WindDTO
    let rain: ForecastRainDTO?
    let sys: ForecastSystemDTO
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, rain, sys
        case dtTxt = "dt_txt"
    }
}
