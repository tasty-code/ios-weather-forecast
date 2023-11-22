//
//  WeatherForecastDataService.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/22/23.
//

import Foundation

protocol DataServiceProtocol {
    associatedtype T
    
    init(networkManager: NetworkManager, locationManager: LocationManager)
    
    func fetchData(_ serviceType: ServiceType, _ completionHandler: @escaping (T) -> Void)
}

final class WeatherForecastDataService<T: Decodable>: DataServiceProtocol {
    private let networkManager: NetworkManager
    private let locationManager: LocationManager
    
    init(networkManager: NetworkManager, locationManager: LocationManager) {
        self.networkManager = networkManager
        self.locationManager = locationManager
    }
    
    func fetchData(_ serviceType: ServiceType, _ completionHandler: @escaping (T?) -> Void) {
        guard let apiKey = Bundle.getAPIKey(for: ApiName.openWeatherMap.name) else {
            return
        }
        
        guard let coordinate = locationManager.fetchCurrentCoordinate2D() else {
            return
        }
        
        var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/\(serviceType.name)")
        urlComponents?.queryItems = [
            URLQueryItem(name: "lat", value: "\(coordinate.latitude)"),
            URLQueryItem(name: "lon", value: "\(coordinate.longitude)"),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]
        
        guard let url = urlComponents?.url else {
            return
        }
        
        networkManager.downloadData(url: url) { [weak self] result in
            switch result {
            case .success(let data):
                let model = self?.decodeJSONToSwift(data)
                completionHandler(model)
            case .failure(let error): print(error)
            }
        }
    }
    
    private func decodeJSONToSwift(_ data: Data?) -> T? {
        guard let data = data else {
            return nil
        }
        
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            return model
        } catch {
            guard let error = error as? DecodingError else { return nil }
            print("Failed to Decoding JSON: \(error)")
        }
        
        return nil
    }
}
