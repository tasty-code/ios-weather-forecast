//
//  WeatherRequest.swift
//  WeatherForecast
//
//  Created by 김경록 on 11/21/23.
//

import Foundation

struct WeatherRequest: APIRequest {
    let scheme: String = "https"
    let host: String = "api.openweathermap.org"
    let method: String = "GET"
    
    var path: String
    var parameters: [String : String]?
    
    init?(latitude: Double, longitude: Double, weatherType: WeatherType) {
        self.path = "/data/2.5/\(weatherType)"
        
        guard let apiKey = Bundle.main.apiKey else { return }
        parameters = [
            "lon": "\(longitude)",
            "lat": "\(latitude)",
            "appid": apiKey,
            "units": "metric"
        ]
    }
}
