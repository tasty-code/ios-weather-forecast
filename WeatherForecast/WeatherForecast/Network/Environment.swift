//
//  Environment.swift
//  WeatherForecast
//
//  Created by Janine on 11/20/23.
//

import Foundation

enum Environment {
    private enum Keys {
        static let API_KEY = "API_KEY"
        static let BASE_URL = "BASE_URL"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist file not found")
        }
        return dict
    }()
    
    static let baseURL: String = {
        guard let string = Environment.infoDictionary[Keys.BASE_URL] as? String else { fatalError("not exists in plist") }
        return string
    }()
    
    static let apiKey: String = {
        guard let string = Environment.infoDictionary[Keys.API_KEY] as? String else { fatalError("not exists in plist") }
        return string
    }()
}
