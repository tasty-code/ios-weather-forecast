//
//  OpenWeatherRepository.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/14.
//

import Foundation

final class OpenWeatherRepository {
    func fetchWeather(lattitude: Double, longitude: Double) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lattitude)&lon=\(longitude)&appid=\(Bundle.main.apiKey)"
        guard let url = URL(string: urlString) else { return }

        let decoder = JSONDecoder()
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                // TODO: 에러 처리
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                // TODO: status code 에러 처리
                return
            }
            
            guard let data else { return }

            do {
                let currentWeather = try decoder.decode(CurrentWeather.self, from: data)
                print(currentWeather)
            } catch {
                // TODO: JSON 디코딩 에러 처리
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
}
