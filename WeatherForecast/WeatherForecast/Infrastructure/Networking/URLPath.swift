//
//  URLPath.swift
//  WeatherForecast
//
//  Created by Jason on 2023/03/16.
//

import Foundation
import CoreLocation

enum URLPath: String {
    case currentWeather = "weather"
    case forecastWeather = "forecast"
    
    var getWeatherMetaType: WeatherModel.Type {
        switch self {
        case .currentWeather:
            return CurrentWeather.self
        case .forecastWeather:
            return ForecastWeather.self
        }
    }
    
    static func configureURL(coordintate: CLLocationCoordinate2D, getPath: URLPath) throws -> URL {
        guard var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/\(getPath.rawValue)") else {
            throw URLError(.badURL)
        }
        
        let latitude = URLQueryItem(name: "lat", value: coordintate.latitude.description)
        let longitude = URLQueryItem(name: "lon", value: coordintate.longitude.description)
        let appid = URLQueryItem(name: "appid", value: Bundle.main.APIKey)
        let unitsOfMeasurement = URLQueryItem(name: "units", value: "metric")

        components.queryItems = [latitude, longitude, appid, unitsOfMeasurement]
        if getPath == .forecastWeather {
            let countOfDay = URLQueryItem(name: "cnt", value: "5")
            components.queryItems?.append(countOfDay)
        }
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        return url
    }
}
