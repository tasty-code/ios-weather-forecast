//
//  Bundle+.swift
//  WeatherForecast
//
//  Created by Mason Kim on 2023/03/14.
//

import Foundation

extension Bundle {
    var apiKey: String {
        guard let file = path(forResource: "WeatherAPIKey", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["API_KEY"] as? String else { return "" }

        return key
    }
}
