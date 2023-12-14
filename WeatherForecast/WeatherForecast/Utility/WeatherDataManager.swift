//
//  WeatherManager.swift
//  WeatherForecast
//
//  Created by BOMBSGIE on 2023/12/12.
//

import Foundation

final class WeatherDataManager: WeatherUpdateDelegate {
    
    private let networkManager: NetworkManagable
    let currentLocationManager: CurrentLocationManager
    
    weak var delegate: UIUpdatable?
    
    private(set) var currentWeather: CurrentWeather?
    private(set) var weeklyWeather: WeeklyWeather?
    
    init(networkManager: NetworkManagable, currentLocationManager: CurrentLocationManager) {
        self.networkManager = networkManager
        self.currentLocationManager = currentLocationManager
    }
    
    func fetchAllWeather() {
        fetchCurrentWeather { [weak self] (weather: CurrentWeather) in
            self?.currentWeather = weather
        }
        fetchWeeklyWeather { [weak self] (weather: WeeklyWeather) in
            self?.weeklyWeather = weather
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.updateUI()
            }
        }
    }
    
    private func fetchCurrentWeather<T: Decodable>(completion: @escaping (T) -> Void) {
        sendRequest(path: WeatherURL.current.path) { (result: Result<T, Error>) in
            switch result {
            case .success(let weather):
                completion(weather)
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    private func fetchWeeklyWeather<T: Decodable>(completion: @escaping (T) -> Void) {
        sendRequest(path: WeatherURL.weekly.path) { (result: Result<T, Error>) in
            switch result {
            case .success(let weather):
                completion(weather)
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    private func sendRequest<T: Decodable>(path: String, completion: @escaping (Result<T, Error>) -> Void) {
        let queries = currentLocationManager.makeQueries()
        networkManager.getData(path: path, with: queries, completion: completion)
    }
}
