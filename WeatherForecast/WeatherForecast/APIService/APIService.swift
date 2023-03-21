//
//  APIService.swift
//  WeatherForecast
//
//  Created by Bora Yang on 2023/03/20.
//

import Foundation

class APIService {

    static let shared = APIService()

    private init() { }

    func fetchCurrentWeather(lat: Double,
                             lon: Double,
                             completion: @escaping (Result<Weather, NetworkingError>) -> Void) {

        let latString = doubleToString(lat)
        let lonString = doubleToString(lon)

        let urlString = "\(WeatherType.currentWeather.urlString)?lat=\(latString)&lon=\(lonString)&appid=\(SecretKey.appId)"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if error != nil {
                completion(.failure(.networkError))
                return
            }

            guard let safeData = data else {
                completion(.failure(.dataError))
                return
            }

            do {
                let currentWeatherData = try JSONDecoder().decode(Weather.self, from: safeData)

                completion(.success(currentWeatherData))
                return

            } catch {
                completion(.failure(.parseError))
                return
            }
        }.resume()
    }

    func fetchFiveDayWeather(lat: Double,
                             lon: Double,
                             completion: @escaping (Result<Forecast, NetworkingError>) -> Void) {

        let latString = doubleToString(lat)
        let lonString = doubleToString(lon)

        let urlString = "\(WeatherType.fiveDayWeather.urlString)?lat=\(latString)&lon=\(lonString)&appid=\(SecretKey.appId)"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if error != nil {
                completion(.failure(.networkError))
                return
            }

            guard let safeData = data else {
                completion(.failure(.dataError))
                return
            }

            do {
                let fiveDayWeatherData = try JSONDecoder().decode(Forecast.self, from: safeData)
                completion(.success(fiveDayWeatherData))
                return
            } catch {
                completion(.failure(.parseError))
                return
            }
        }.resume()
    }

    func doubleToString(_ number: Double) -> String {
        return String(number)
    }
}
