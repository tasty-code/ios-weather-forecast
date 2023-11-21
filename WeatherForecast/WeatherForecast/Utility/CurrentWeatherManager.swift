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
            guard let filePath = Bundle.main.path(forResource: "APIKeyList", ofType: "plist") else {
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
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=37.715122&lon=126.734086&appid=\(apiKey)") else { return }
        
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let weatherResponse = try? JSONDecoder().decode(FiveDaysWeatherDTO.self, from: data)
                DispatchQueue.main.async {
                    
                }
            } catch(let error) {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
}

