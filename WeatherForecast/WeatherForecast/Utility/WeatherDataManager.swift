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
    private let urlFormatter: any URLFormattable = WeatherURLFormatter()
    
    weak var delegate: UIUpdatable?
    
    private(set) var currentWeather: CurrentWeather?
    private(set) var weeklyWeather: WeeklyWeather?
    
    init(networkManager: NetworkManagable, currentLocationManager: CurrentLocationManager) {
        self.networkManager = networkManager
        self.currentLocationManager = currentLocationManager
    }
    
    func sendRequest() {
        let queries = currentLocationManager.makeQueries()
        networkManager.getData(formatter: urlFormatter, path: WeatherDataURL.current.path, with: queries) { [weak self] result in
            switch result {
            case .success(let data):
                guard let weather = try? JSONDecoder().decode(CurrentWeather.self, from: data) else {
                    //Alert Delegate
                    return
                }
                self?.currentWeather = weather
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
        networkManager.getData(formatter: urlFormatter, path: WeatherDataURL.weekly.path, with: queries) { [weak self] result in
            switch result {
            case .success(let data):
                guard let weather = try? JSONDecoder().decode(WeeklyWeather.self, from: data) else {
                    return
                }
                self?.weeklyWeather = weather
                
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.updateUI()
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }
}
