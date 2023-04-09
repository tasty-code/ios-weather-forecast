//
//  UseCase.swift
//  WeatherForecast
//
//  Created by 박재우 on 2023/04/07.
//

import CoreLocation

final class UseCase {
    
    weak var delegate: WeatherModelDelegate?
    
    private let repository: Repository
    private var storage = [String:Data]()
    
    init() {
        self.repository = Repository()
    }
    
    func receiveCurrentLocation() -> CLLocationCoordinate2D {
        guard let location = UserLocation.shared.location?.coordinate else {
            //TODO: - Error 처리
            return CLLocationCoordinate2D()
        }
        return location
    }
    
    func determine(with location: CLLocationCoordinate2D) {
        URLPath.allCases.forEach { path in
            switch path {
            case .currentWeather:
                repository.loadData(with: location,
                                    path: path) { weatherModel, error in
                    DispatchQueue.main.async {
                        if let currentWeatherModel = weatherModel as? CurrentWeather {
                            let result = self.makeCurrentWeather(with: currentWeatherModel)
                            self.delegate?.loadCurrentWeather(of: result)
                        }
                    }
                }
            case .forecastWeather:
                repository.loadData(with: location,
                                    path: path) { weatherModel, error in
                    DispatchQueue.main.async {
                        if let forecastWeatherModel = weatherModel as? ForecastWeather {
                            self.delegate?.loadForecastWeather(of: self.makeForecastWeather(with: forecastWeatherModel))
                        }
                    }
                }
            }
        }
    }
    
    func loadIconImage() {
        repository.loadIcon { (data, error) in
            DispatchQueue.main.async {
                let element = URLPath.iconList.removeFirst()
                
                guard let certifiedData = data else {
                    return
                }
                
                self.storage[element] = certifiedData
            }
        }
    }
    
    //MARK: - Private Method
    
    private func makeCurrentWeather(with data: CurrentWeather) -> CurrentViewModel {
        var iconData: Data = Data()
        let minTemperature = data.main.temperatureMin
        let maxTemperature = data.main.temperatureMax
        let currentTemperature = data.main.temperature
        let temperature = Temperature(lowestTemperature: String(minTemperature),
                                      highestTemperature: String(maxTemperature),
                                      currentTemperature: String(currentTemperature))
        
        if let weather = data.weathers.first, let data = storage[weather.icon] {
            iconData = data
        }
        
        return CurrentViewModel(currentWeatherIcon: iconData, temperature: temperature)
    }
    
    private func makeForecastWeather(with data: ForecastWeather) -> [ForecastViewModel] {
        
        var forecastViewModels = [ForecastViewModel]()
        
        data.list.forEach { element in
            let forecastDate: String = element.date
            let forecastTemperature: Double = element.main.temperature
            let forecastInformation = ForecastInformation(forecastDate: forecastDate, forecastDegree: String(forecastTemperature))
            var forecastIcon: Data = Data()
            
            if let icon = element.weather.first?.icon {
                guard let iconData = storage[icon] else {
                    return
                }
                forecastIcon = iconData
            }
            
            let forecastViewModel = ForecastViewModel(forecastEmogi: forecastIcon, forecastInformation: forecastInformation)
            forecastViewModels.append(forecastViewModel)
        }
        
        return forecastViewModels
    }
}

protocol WeatherModelDelegate: NSObject {
    func loadCurrentWeather(of model: CurrentViewModel)
    func loadForecastWeather(of model: [ForecastViewModel])
}

