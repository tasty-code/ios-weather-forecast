//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 이상윤 on 2023/03/21.
//

import Foundation
import CoreLocation

final class NetworkManager: OpenWeatherURLProtocol, NetworkTaskProtcol {
    // MARK: - Private property
    private(set) var latitude: Double = 37.533624
    private(set) var longitude: Double = 126.963206

    // MARK: - Public property
    var weatherData: Weather?
    var forecastData: Forecast?
    
    // MARK: - Public
    func callAPI() {
        callWeatherAPI()
        callForecastAPI()
    }

    func updateLocation(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    // MARK: - Private
    private func callWeatherAPI() {
        do {
            let weatherURLString = weatherURL(lat: latitude, lon: longitude)
            let weatherURL = try getURL(string: weatherURLString)
            var weatherURLRequest = URLRequest(url: weatherURL)
            
            weatherURLRequest.httpMethod = "GET"
            
            dataTask(URLRequest: weatherURLRequest, myType: Weather.self) { result in
                switch result {
                case .success(let data):
                    guard self.hasWeatherDataChanged(from: data) else { return }
                    self.weatherData = data
                    print("[NetworkManager](fetched)weatherData")
                case .failure(let error):
                    print("[NetworkManager]dataTask error: ", error)
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
            var forecastURLRequest = URLRequest(url: forecastURL)
            
            forecastURLRequest.httpMethod = "GET"
            
            dataTask(URLRequest: forecastURLRequest, myType: Forecast.self) { result in
                switch result {
                case .success(let data):
                    guard self.hasForecastDataChanged(from: data) else { return }
                    self.forecastData = data
                    print("[NetworkManager](fetched)forecastData")
                case .failure(let error):
                    print("[NetworkManager]dataTask error: ", error)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func hasForecastDataChanged(from: Forecast) -> Bool {
        if from.city.name == self.forecastData?.city.name &&
            from.list.first?.timeOfDataText == self.forecastData?.list.first?.timeOfDataText &&
            from.list.first?.weather.description == self.forecastData?.list.first?.weather.description
        {
            return false
        }
        
        return true
    }
    
    private func hasWeatherDataChanged(from: Weather) -> Bool {
        if from.name == self.weatherData?.name &&
            from.main.temp == self.weatherData?.main.temp
        {
            return false
        }
        
        return true
    }
}
