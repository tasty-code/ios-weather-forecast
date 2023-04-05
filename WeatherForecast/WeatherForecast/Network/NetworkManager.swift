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
    
    // MARK: - Lifelcycle
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(getCoordinate(notification:)), name: Notification.Name.location, object: nil)
    }

    // MARK: - Helper
    @objc func getCoordinate(notification: Notification) {
        guard let coordinate = notification.userInfo?[NotificationKey.coordinate] as? CLLocationCoordinate2D else { return }
        latitude = coordinate.latitude
        longitude = coordinate.longitude
        callAPI()
    }
    
    // MARK: - Public
    func callAPI() {
        callWeatherAPI()
        callForecastAPI()
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
                    guard self.hasDataChanged(from: data) else { return }
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
    private func hasDataChanged(from: Forecast) -> Bool {
        if from.city.name == self.forecastData?.city.name &&
            from.list.first?.timeOfDataText == self.forecastData?.list.first?.timeOfDataText &&
            from.list.first?.weather.description == self.forecastData?.list.first?.weather.description
        {
            return false
        }
        
        return true
    }
}
