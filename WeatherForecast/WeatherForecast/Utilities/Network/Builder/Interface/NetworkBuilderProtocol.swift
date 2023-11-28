//
//  NetworkBuilderProtocol.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/28/23.
//

import Foundation

protocol NetworkBuilderProtocol {
    associatedtype Response
    
    var baseURL: ApiType { get }
    var path: String { get }
    var headers: [String: String] { get }
    var parameters: [URLQueryItem] { get }
    var serviceType: ServiceType { get }
}

extension NetworkBuilderProtocol {
    var baseURL: ApiType { .openWeatherMap }
    var headers: [String: String] { [:] }
}
