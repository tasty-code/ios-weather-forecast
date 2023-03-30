//
//  NetworkError.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/03/22.
//

import Foundation

enum NetworkError: String, Error {
    case transportError
    case serverError
    case missingData
    case decodingError
}
