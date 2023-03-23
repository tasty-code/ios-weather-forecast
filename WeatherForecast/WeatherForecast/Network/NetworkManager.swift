//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 이상윤 on 2023/03/21.
//

import Foundation

final class NetworkManager: OpenWeatherURLProtocol, NetworkTaskProtcol {
    private(set) var lat: Double = 37.533624
    private(set) var lon: Double = 126.963206
    var weatherData: Weather?
    var forecastData: Forecast?

    func callAPI() {
        callWeatherAPI()
        callForecastAPI()
    }

    private func callWeatherAPI() {
        let weatherURLString = weatherURL(lat: lat, lon: lon)
        print(weatherURLString)
        guard let weatherURL = URL(string: weatherURLString) else {
            print("invalid URL")
            return
        }
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
    }

    private func callForecastAPI() {
        let forecastURLString = forecastURL(lat: lat, lon: lon)
        guard let forecastURL = URL(string: forecastURLString) else {
            print("invalid URL")
            return
        }
        let forecastURLRequest = URLRequest(url: forecastURL)
        print(forecastURLString)
        dataTask(URLRequest: forecastURLRequest, myType: Forecast.self) { result in
            switch result {
            case .success(let data):
                self.forecastData = data
                print("forecastData성공")
            case .failure(let error):
                print("dataTask error: ", error)
            }
        }
    }
}
