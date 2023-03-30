//
//  NetworkEntityLoadingError.swift
//  WeatherForecast
//
//  Created by Jason on 2023/03/28.
//

import Foundation

enum NetworkEntityLoadingError: Error {
    case networkFailure
    case invalidData
}
