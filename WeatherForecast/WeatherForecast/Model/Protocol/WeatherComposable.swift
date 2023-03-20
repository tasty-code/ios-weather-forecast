//
//  WeatherComposable.swift
//  WeatherForecast
//
//  Created by J.E on 2023/03/15.
//

import Foundation

protocol WeatherComposable: Decodable {
    static var weatherRange: WeatherRange { get }
}
