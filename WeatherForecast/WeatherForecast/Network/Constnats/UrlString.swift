//
//  UrlString.swift
//  WeatherForecast
//
//  Created by Janine on 12/1/23.
//

import Foundation

enum UrlString: Decodable {
    case weather(latitude: String, longitude: String)
    case icon(iconId: String)

}

extension UrlString {
    var parameter: String {
        switch self {
        case .weather(let latitude, let longitude):
            return "?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(Environment.apiKey)"
        case .icon(let iconId):
            return "\(iconId)@2x.png"
        }
    }
}
