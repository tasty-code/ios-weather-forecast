//
//  WeatherNetworkError.swift
//  WeatherForecast
//
//  Created by Blu on 2023/03/14.
//

import Foundation

enum WeatherNetworkError: Error {
    case invalidURL, invalidRequest, invalidData
}
