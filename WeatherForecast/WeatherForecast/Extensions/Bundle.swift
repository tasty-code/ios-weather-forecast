//
//  Bundle.swift
//  WeatherForecast
//
//  Created by 김진웅 on 11/21/23.
//

import Foundation

extension Bundle {
    var apiKey: String? {
        guard let file = self.path(forResource: "WeatherAPI", ofType: "plist"),
              let resource = NSDictionary(contentsOf: URL(fileURLWithPath: file)),
              let key = resource["API_KEY"] as? String
        else {
            return nil
        }
        return key
    }
}
