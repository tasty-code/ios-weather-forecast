//
//  WeatherInformationDTO.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/04/04.
//

import Foundation

struct WeatherInformationDTO: Decodable {
    let id: Int?
    let main, description, icon: String?
}
