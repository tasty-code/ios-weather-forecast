//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 이상윤 on 2023/03/21.
//

import Foundation

final class NetworkManager: OpenWeatherURLProtocol, NetworkTaskProtcol {
    private(set) var latitude: Double = 37.533624
    private(set) var longitude: Double = 126.963206
    var weatherData: Weather?
    var forecastData: Forecast?
    
    func callAPI() {
        callWeatherAPI()
        callForecastAPI()
    }
    
    private func callWeatherAPI()  {
        do {
            let weatherURLString = weatherURL(lat: latitude, lon: longitude)
            let weatherURL = try getURL(string: weatherURLString)
            let weatherURLRequest = URLRequest(url: weatherURL)
            dataTask(URLRequest: weatherURLRequest, myType: Weather.self) { result in
                switch result {
                case .success(let data):
                    self.weatherData = data
                    print("weatherData성공")
                case .failure(let error):
                    print("dataTask error: ", error)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func getURL(string: String) throws -> URL {
        guard let weatherURL = URL(string: string) else {
            throw NetworkError.invalidURL
        }
        return weatherURL
    }
    
    private func callForecastAPI() {
        do {
            let forecastURLString = forecastURL(lat: latitude, lon: longitude)
            let forecastURL = try getURL(string: forecastURLString)
            let forecastURLRequest = URLRequest(url: forecastURL)
            dataTask(URLRequest: forecastURLRequest, myType: Forecast.self) { result in
                switch result {
                case .success(let data):
                    self.forecastData = data
                    print("forecastData성공")
                case .failure(let error):
                    print("dataTask error: ", error)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
