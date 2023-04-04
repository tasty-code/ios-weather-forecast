//
//  WeatherResponseDTO.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/03/30.
//

import Foundation

struct WeatherResponseDTO: Decodable {
    let visibility, dt, timezone, id, cod: Int?
    let base, name: String?
    let coord: CoordinateDTO?
    let weather: [WeatherInformationDTO]
    let main: TemperatureInformationDTO?
    let wind: WindDTO?
    let rain: WeatherRainDTO?
    let clouds: CloudsDTO?
    let sys: WeatherSystemDTO?
}
