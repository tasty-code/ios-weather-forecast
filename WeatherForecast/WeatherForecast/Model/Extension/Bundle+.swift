//
//  Bundle+.swift
//  WeatherForecast
//
//  Created by Blu on 2023/03/17.
//

import Foundation

extension Bundle {
    var apiKey: String {
        guard let file = self.path(forResource: "Info", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["WeatherApiKey"] as? String else {
            return WeatherNetworkError.apiKeyNotFound.description
        }

        return key
    }
}
