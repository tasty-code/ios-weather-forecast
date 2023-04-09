//
//  URLPath.swift
//  WeatherForecast
//
//  Created by Jason on 2023/03/16.
//

import CoreLocation

enum URLPath: String, CaseIterable {
    case currentWeather
    case forecastWeather
    
    static var iconList = ["01d", "01n", "02d", "02n", "03d", "03n","04d", "04n",
                           "09d", "09n", "10d", "10n", "11d", "11n", "13d", "13n",
                           "50d", "50n",]
    
    var weatherMetaType: WeatherModel.Type {
        switch self {
        case .currentWeather:
            return CurrentWeather.self
        case .forecastWeather:
            return ForecastWeather.self
        }
    }
    
    var path: String {
        switch self {
        case .currentWeather:
            return "weather"
        case .forecastWeather:
            return "forecast"
        }
    }
    
    static func configureURL(of weatherCastType: URLPath, with coordintate: CLLocationCoordinate2D) throws -> URL {
        let baseURL: String = "https://api.openweathermap.org/data/2.5/"
        let latitude = URLQueryItem(name: OpenWeatherParameter.latitude, value: coordintate.latitude.description)
        let longitude = URLQueryItem(name: OpenWeatherParameter.longitude, value: coordintate.longitude.description)
        let unitsOfMeasurement = URLQueryItem(name: OpenWeatherParameter.measurement, value: Measurement.celsius)
        
        guard let weatherAPIKEY = Bundle.main.object(forInfoDictionaryKey: "WeatherAPIKEY") as? String else {
            fatalError("Weather API KEY is E.M.P.T.Y !!")
        }
        
        guard var components = URLComponents(string: "\(baseURL)\(weatherCastType.path)") else {
            throw URLComponentsError.invalidComponent
        }
        
        let appid = URLQueryItem(name: OpenWeatherParameter.apiKey, value: weatherAPIKEY)
        components.queryItems = [latitude, longitude, appid, unitsOfMeasurement]
        
        guard let url = components.url else {
            throw URLComponentsError.invalidComponent
        }
        
        return url
    }
    
    static func configureIconURL(of iconDescription: String) throws -> URL {
        let baseURL: String = "https://openweathermap.org/img/wn/"
        
        guard let components = URLComponents(string: "\(baseURL)\(iconDescription)" + "@2x.png" ) else {
            throw URLComponentsError.invalidComponent
        }
        
        guard let url = components.url else {
            throw URLComponentsError.invalidComponent
        }
        
        return url
    }
}
