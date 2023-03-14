//
//  OpenWeatherRepository.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/14.
//

import Foundation

final class OpenWeatherRepository {
    func fetchWeather(lattitude: Double, longitude: Double) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lattitude)&lon=\(longitude)&appid=\(Bundle.main.apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { return }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else { return }
            
            guard let data else { return }
            print(data)
        }
        
        task.resume()
    }
    
}
