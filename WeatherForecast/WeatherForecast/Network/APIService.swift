//
//  APIService.swift
//  WeatherForecast
//
//  Created by Bora Yang on 2023/03/20.
//

import Foundation

protocol APIServiceProtocol {
    func fetchWeatherAPI(coordinate: Coordinate, completion: @escaping (Result<Weather, NetworkError>) -> Void)
    func fetchForecastAPI(coordinate: Coordinate, completion: @escaping (Result<Forecast, NetworkError>) -> Void)
}

extension APIServiceProtocol {
    
}

final class APIService: APIServiceProtocol {

    static let shared = APIService()

    private let baseURL = "https://api.openweathermap.org/data/2.5"

    private init() { }

    func fetchWeatherAPI(coordinate: Coordinate, completion: @escaping (Result<Weather, NetworkError>) -> Void) {

        guard let lat = doubleToString(coordinate.lat),
              let lon = doubleToString(coordinate.lon) else { return }

        let urlString =  "\(baseURL)/\(URLPath.weather)?lat=\(lat)&lon=\(lon)&appid=\(SecretKey.appId)"

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

    func fetchForecastAPI(coordinate: Coordinate, completion: @escaping (Result<Forecast, NetworkError>) -> Void) {

        guard let lat = doubleToString(coordinate.lat),
              let lon = doubleToString(coordinate.lon) else { return }

        let urlString =  "\(baseURL)/\(URLPath.forecast)?lat=\(lat)&lon=\(lon)&appid=\(SecretKey.appId)"
        
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
}

extension APIService {
    private func doubleToString(_ number: Double?) -> String? {
        guard let number else { return nil }
        return String(number)
    }
}
