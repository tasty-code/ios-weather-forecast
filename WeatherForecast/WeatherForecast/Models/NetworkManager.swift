//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 김진웅 on 11/20/23.
//

import Foundation

final class NetworkManager {
    func fetchCurrentWeather(latitude: Double,
                             longitude: Double,
                             completionHandler: @escaping (CurrentWeather?)-> Void) {
        
        guard let url = URL(string: WeatherType.current.fetchURL(lon: longitude, lat: latitude))
        else {
            completionHandler(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                print("Error: error calling GET")
                print(error!)
                completionHandler(nil)
                return
            }
            
            guard let safeData = data else {
                print("Error: Did not receive data")
                completionHandler(nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200 ..< 299) ~= response.statusCode
            else {
                print("Error: HTTP request failed")
                completionHandler(nil)
                return
            }
            
            let currentWeather = try? JSONDecoder().decode(CurrentWeather.self, from: safeData)
            completionHandler(currentWeather)
        }.resume()
    }
}
