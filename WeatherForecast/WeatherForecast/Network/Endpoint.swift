//
//  Endpoint.swift
//  WeatherForecast
//
//  Created by Janine on 11/20/23.
//

import Foundation

enum Endpoint: String, CaseIterable, Decodable {
    case weather
    case forecast
}
