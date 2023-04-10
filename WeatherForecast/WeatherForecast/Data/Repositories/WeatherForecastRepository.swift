//
//  WeatherForecastRepository.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/04/03.
//

import Foundation

final class WeatherForecastRepository: WeatherForecastRepositoryInterface {
    
    private let service: NetworkService
    
    init(service: NetworkService) {
        self.service = service
    }
}

extension WeatherForecastRepository {
    
    func fetchWeather(lat: String, lon: String, completion: @escaping (Result<WeatherResponseDTO, NetworkError>) -> Void) {
        
        guard let url = makeURL(path: NetworkConfig.URLPath.weather.rawValue, lat: lat, lon: lon) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        service.performRequest(request: request, completion: completion)
    }
    
    func fetchForecast(lat: String, lon: String, completion: @escaping (Result<ForecastResponseDTO, NetworkError>) -> Void) {
        
        guard let url = makeURL(path: NetworkConfig.URLPath.forecast.rawValue, lat: lat, lon: lon) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        service.performRequest(request: request, completion: completion)
    }
}

extension WeatherForecastRepository {
    
    private func makeURL(path: String, lat: String, lon: String) -> URL? {
        
        var urlComponents = URLComponents(string: "\(NetworkConfig.baseURL)/\(path)")
        
        let latQuery = URLQueryItem(name: "lat", value: lat)
        let lonQuery = URLQueryItem(name: "lon", value: lon)
        let appIdQuery = URLQueryItem(name: "appid", value: SecretKey.appId)
        let langQuery = URLQueryItem(name: "lang", value: "kr")
        
        urlComponents?.queryItems = [latQuery, lonQuery, appIdQuery, langQuery]
        
        return urlComponents?.url
    }
}
