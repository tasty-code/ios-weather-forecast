//
//  APIRequest.swift
//  WeatherForecast
//
//  Created by 김진웅 on 11/23/23.
//

import Foundation

protocol APIRequest {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: String { get }
    var parameters: [String: String]? { get }
}
