//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/20/23.
//

import Foundation

final class NetworkManager {
    static let `default` = NetworkManager() // singleton
    private let openWeatherMapKey: String = ApiName.openWeatherMap.name
    var weatherModel: WeatherModel?
    
    private init() {}
    
    func downloadData(urlString: String) -> WeatherModel? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse,
                  response.statusCode >= 200 && response.statusCode < 300
            else {
                return
            }
            
            self?.weatherModel = try? JSONDecoder().decode(WeatherModel.self, from: data)
            
        }.resume()
        
        return weatherModel
    }
    
    
}
