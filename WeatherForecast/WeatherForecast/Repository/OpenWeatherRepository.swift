//
//  OpenWeatherRepository.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/14.
//

import Foundation

final class OpenWeatherRepository {
    
    func fetchWeather(lattitude: Double, longitude: Double, completion: @escaping (Result<CurrentWeather, NetworkError>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lattitude)&lon=\(longitude)&appid=\(Bundle.main.apiKey)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let decoder = JSONDecoder()
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.networkingError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.responseError))
                return
            }
            
            guard let data else {
                completion(.failure(.invalidData))
                return
            }

            do {
                let currentWeather = try decoder.decode(CurrentWeather.self, from: data)
                completion(.success(currentWeather))
            } catch {
                completion(.failure(.parseError))
            }
        }
        task.resume()
    }
}
