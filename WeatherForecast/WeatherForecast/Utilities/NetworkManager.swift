//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/20/23.
//

import Foundation

protocol DataServiceProtocol {
    func fetchData(_ serviceType: ServiceType)
}

final class WeatherDataService: DataServiceProtocol {
    private var weatherModel: WeatherModel? = nil
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchData(_ serviceType: ServiceType) {
        guard let apiKey = Bundle.getAPIKey(for: ApiName.openWeatherMap.name) else { return }
        let urlString = "https://api.openweathermap.org/data/2.5/\(serviceType)?lat=32.98&lon=44.11&appid=\(apiKey)&units=metric&lang=kr"
        
        guard let downloadedData = networkManager.downloadData(urlString: urlString) else { return }
        weatherModel = try? JSONDecoder().decode(WeatherModel.self, from: downloadedData)
    }
}

final class NetworkManager {
    static let `default` = NetworkManager()
    
    private init() {}
    
    func downloadData(urlString: String) -> Data? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        var downloadedData: Data? = nil
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse,
                  response.statusCode >= 200 && response.statusCode < 300
            else { return }
            
            downloadedData = data
        }.resume()
        
        return downloadedData
    }
}
