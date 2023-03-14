//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 송선진 on 2023/03/14.
//

import UIKit

class NetworkManager {
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }

    func makeURL() -> URL {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=37&lon=126&units=metric&appid=\(APIKeyManager.openWeather.apiKey)")!
        return url
    }
    
    func fetchWeatherInformation() {
        let url = makeURL()
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                print("error")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                print("error")
                return
            }
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let weatherInSeoul = try decoder.decode(CurrentWeather.self, from: data)
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
}
