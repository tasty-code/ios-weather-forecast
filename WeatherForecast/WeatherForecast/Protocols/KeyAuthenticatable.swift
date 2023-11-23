//
//  KeyAuthenticatable.swift
//  WeatherForecast
//
//  Created by 동준 on 11/23/23.
//

import Foundation

protocol KeyAuthenticatable {
    var apiKey: String { get throws }
}
