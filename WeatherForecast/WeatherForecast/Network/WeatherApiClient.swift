//
//  ApiClient.swift
//  WeatherForecast
//
//  Created by 김예준 on 11/21/23.
//

import CoreLocation

struct WeatherApiClient {
    private static let baseURL = "https://api.openweathermap.org/data/2.5/"
    
    static func makeURL(weatherType: WeatherType, coord: CLLocationCoordinate2D) -> URL? {
        // let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
        let apiKey = "9025fdb78bf735a4b7287e0dcc03e4fd"
        var components = URLComponents(string: baseURL)
        components?.path += weatherType.path
        
        let latQueryItem = URLQueryItem(name: "lat", value: String(coord.latitude))
        let lonQueryItem = URLQueryItem(name: "lon", value: String(coord.longitude))
        let apiKeyQueryItem = URLQueryItem(name: "appid", value: apiKey)
        components?.queryItems = [latQueryItem, lonQueryItem, apiKeyQueryItem]
        
        return components?.url
    }
    
    static func makeRequest(weatherType: WeatherType, coord: CLLocationCoordinate2D) throws -> URLRequest {
        guard let url = makeURL(weatherType: weatherType, coord: coord) else { throw NetworkError.invailedURL }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
