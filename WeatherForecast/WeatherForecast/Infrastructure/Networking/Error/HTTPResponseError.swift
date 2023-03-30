//
//  HTTPResponseError.swift
//  WeatherForecast
//
//  Created by Jason on 2023/03/28.
//

import Foundation

enum HTTPResponseError: Error {
    case error(statusCode: Int, description: String)
}
