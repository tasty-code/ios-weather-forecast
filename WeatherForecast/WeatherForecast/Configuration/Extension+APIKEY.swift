//
//  Extension+APIKEY.swift
//  WeatherForecast
//
//  Created by Jason on 2023/03/14.
//

import Foundation

extension Bundle {
    var APIKey: String {
        guard let file = self.path(forResource: "API+KEY", ofType: "plist") else {
            return ""
        }
        
        guard let resource = NSDictionary(contentsOfFile: file) else {
            return ""
        }
        
        guard let key = resource["API_Key"] as? String else {
            fatalError("API+KEY에 APIKey를 설정하세요.")
        }
        return key
    }
}
