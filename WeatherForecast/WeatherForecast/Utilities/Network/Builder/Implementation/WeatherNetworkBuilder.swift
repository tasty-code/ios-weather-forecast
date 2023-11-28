//
//  NetworkBuilder.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/28/23.
//

import Foundation

struct WeatherNetworkBuilder: NetworkBuilderProtocol {
    typealias Response = WeatherModel
    
    let path: String
    let parameters: [URLQueryItem]
    let serviceType: ServiceType
    
    init(for type: ServiceType) {
        self.path = type.path
        self.parameters = type.queries
        self.serviceType = type
    }
}
