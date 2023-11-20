//
//  Environment.swift
//  WeatherForecast
//
//  Created by Janine on 11/20/23.
//

import Foundation

enum Environment {
    private enum Keys {
        static let apiKey = "ApiKey"
        static let baseUrl = "BaseURL"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist file not found")
        }
        return dict
    }()
    
    static let baseURL: String = {
        guard let string = Environment.infoDictionary[Keys.baseUrl] as? String else { fatalError("not exists in plist") }
        return string
    }()
    
    static let apiKey: String = {
        guard let string = Environment.infoDictionary[Keys.apiKey] as? String else { fatalError("not exists in plist") }
        return string
    }()
}
