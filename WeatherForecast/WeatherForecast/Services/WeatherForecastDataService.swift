//
//  WeatherForecastDataService.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/22/23.
//

import Foundation

protocol DataServiceProtocol {
    init(networkManager: NetworkManager)
    
    func fetchData(_ serviceType: ServiceType)
}

final class WeatherForecastDataService<T: Decodable>: DataServiceProtocol {
    private var dataModel: T?
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchData(_ serviceType: ServiceType) {
        guard let apiKey = Bundle.getAPIKey(for: ApiName.openWeatherMap.name) else {
            return
        }
        
        var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/\(serviceType.name)")
        urlComponents?.queryItems = [
            URLQueryItem(name: "lat", value: "32.98"),
            URLQueryItem(name: "lon", value: "44.11"),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]
        
        guard let url = urlComponents?.url else {
            return
        }
        
        networkManager.downloadData(url: url) { [weak self] downloadedData in
            guard let data = downloadedData else {
                return
            }
            
            do {
                self?.dataModel = try JSONDecoder().decode(T.self, from: data)
            } catch {
                guard let error = error as? DecodingError else { return }
                print("Failed to Decoding JSON: \(error)")
            }
        }
    }
    
    func foo() -> T? {
        guard let model = dataModel else { return nil }
        return model
    }
}
