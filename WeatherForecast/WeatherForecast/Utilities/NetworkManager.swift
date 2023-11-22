//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/20/23.
//

import Foundation

protocol DataServiceProtocol {
    init(networkManager: NetworkManager)
    
    func fetchData(_ serviceType: ServiceType)
}

final class WeatherDataService: DataServiceProtocol {
    private var weatherModel: WeatherModel? = nil
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchData(_ serviceType: ServiceType) {
        guard let apiKey = Bundle.getAPIKey(for: ApiName.openWeatherMap.name) else {
            return
        }
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/\(serviceType.description)?lat=32.98&lon=44.11&appid=\(apiKey)&units=metric&lang=kr") else { return
        }
        
        networkManager.downloadData(url: url) { [weak self] downloadedData in
            guard let data = downloadedData else {
                return
            }
            guard let weatherModel = try? JSONDecoder().decode(WeatherModel.self, from: data) else {
                return
            }
            
            self?.weatherModel = weatherModel
        }
    }
}

final class ForecastDataService: DataServiceProtocol {
    private var forecastModel: ForecastModel? = nil
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchData(_ serviceType: ServiceType) {
        guard let apiKey = Bundle.getAPIKey(for: ApiName.openWeatherMap.name) else {
            return
        }
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/\(serviceType.description)?lat=32.98&lon=44.11&appid=\(apiKey)&units=metric&lang=kr") else { return
        }
        
        networkManager.downloadData(url: url) { [weak self] downloadedData in
            guard let data = downloadedData else {
                return
            }
            self?.forecastModel = try? JSONDecoder().decode(ForecastModel.self, from: data)
        }
        
    }
}

final class NetworkManager {
    private enum ResponseStatus {
        case success, failure
        
        static func check(_ statusCode: Int) -> ResponseStatus {
            switch statusCode {
            case 200..<300: ResponseStatus.success
            default: ResponseStatus.failure
            }
        }
    }
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func downloadData(url: URL, _ completionHandler: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse,
                  ResponseStatus.check(response.statusCode) == .success 
            else {
                return
            }
            
            completionHandler(data)
        }.resume()
    }
}
