//
//  CurrentWeatherManager.swift
//  WeatherForecast
//
//  Created by 동준 on 11/21/23.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case noData
    case decodingError
}

class CurrentWeatherManager {
    private var apiKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "ApiKeyList", ofType: "plist") else {
                fatalError("Couldn`t find ApiKeyList")
            }
            
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "OPENWEATHERMAP_KEY") as? String else {
                fatalError("Couldn`t find key 'OPENWEATHERMAP_KEY'")
            }
            return value
        }
    }
    
    func fetchWeather(completion: @escaping (Result<CurrentWeatherDTO, NetworkError>) -> Void) {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/\(CurrentWeatherDTO.self)?lat=37.715122&lon=126.734086&appid=\(apiKey)")
    
        guard let url = url else {
            return completion(.failure(.badUrl))
        }
        
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
          
            let weatherResponse = try? JSONDecoder().decode(CurrentWeatherDTO.self, from: data)

            if let weatherResponse = weatherResponse {
                print(weatherResponse)
                completion(.success(weatherResponse))
            } else {
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
}

