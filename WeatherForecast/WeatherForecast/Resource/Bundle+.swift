//
//  Bundle+.swift
//  WeatherForecast
//
//  Created by Blu on 2023/03/17.
//

import Foundation

extension Bundle {
    var apiKey: String {
        guard let file = self.path(forResource: "Info", ofType: "plist") else {
            print("invalidPath")
            return "invalidPath"
        }
        guard let resource = NSDictionary(contentsOfFile: file) else {
            print("invaildDictionary")
            return "invaildDictionary"
        }
        guard let key = resource["WeatherApiKey"] as? String else {
            fatalError("invalid API KEY")
        }
        return key
    }
}
