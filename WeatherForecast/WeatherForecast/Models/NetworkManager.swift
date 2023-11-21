//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 김진웅 on 11/20/23.
//

import Foundation

final class NetworkManager {
    
    func fetchWeather<T: Decodable>(weatherType: WeatherType,
                                    latitude: Double,
                                    longitude: Double,
                                    completionHandler: @escaping (T?)-> Void) {
        
        guard let url = URL(string: weatherType.fetchURL(lon: longitude, lat: latitude))
        else {
            print("올바른 URL이 아닙니다.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("에러 발생")
                print(error)
                return
            }
            
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200 ..< 299) ~= response.statusCode
            else {
                print("응답 코드 에러")
                print("Error: HTTP request failed")
                return
            }
            
            do {
                let weather = try JSONDecoder().decode(T.self, from: data)
                completionHandler(weather)
            } catch {
                print("디코딩 불가")
                print(error)
            }
        }.resume()
    }
}
