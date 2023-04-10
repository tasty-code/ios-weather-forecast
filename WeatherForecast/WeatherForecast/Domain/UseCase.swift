//
//  UseCase.swift
//  WeatherForecast
//
//  Created by 박재우 on 2023/04/07.
//

import CoreLocation
import UIKit

final class UseCase {
    
    weak var delegate: WeatherModelDelegate?
    
    private let repository: Repository
    private var cashedImage = NSCache<NSString, UIImage>()
    
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
            
            DispatchQueue.main.async { [self] in
                let myGroup = DispatchGroup()
                var currentLocation = ""
                
                switch path {
                case .currentWeather:
                    repository.loadData(with: location,
                                        path: path) { weatherModel, error in
                        
                        myGroup.enter()
                        UserLocation.shared.address { address, error in
                            if let swapLocation = address {
                                currentLocation = swapLocation
                            }
                            myGroup.leave()
                        }
                        
                        let loadCurrentWeather = DispatchWorkItem {
                            if let currentWeatherModel = weatherModel as? CurrentWeather {
                                let result = self.makeCurrentWeather(with: currentWeatherModel, address: currentLocation)
                                self.delegate?.loadCurrentWeather(of: result)
                            }
                        }
                        myGroup.notify(queue: .main, work: loadCurrentWeather)
                    }
                case .forecastWeather:
                    repository.loadData(with: location,
                                        path: path) { weatherModel, error in
                        
                        let loadForecastWeather = DispatchWorkItem {
                            if let forecastWeatherModel = weatherModel as? ForecastWeather {
                                self.delegate?.loadForecastWeather(of: self.makeForecastWeather(with: forecastWeatherModel))
                            }
                        }
                        DispatchQueue.main.async(group: myGroup, execute: loadForecastWeather)
                    }
                }
            }
        }
    }
    
    func loadIconImage() {
        repository.loadIcon { (data, error) in
            DispatchQueue.main.async {
                let element = URLPath.iconList.removeFirst()
                
                guard let certifiedData = data,
                      let iconImage = UIImage(data: certifiedData) else {
                    return
                }
                
                self.cashedImage.setObject(iconImage, forKey: element as NSString)
            }
        }
    }
    
    //MARK: - Private Method
    
    private func makeCurrentWeather(with data: CurrentWeather, address: String) -> CurrentViewModel {
        var iconData: UIImage = UIImage()
        
        let minTemperature = data.main.temperatureMin
        let maxTemperature = data.main.temperatureMax
        let currentTemperature = data.main.temperature
        let temperature = Temperature(lowestTemperature: minTemperature,
                                      highestTemperature: maxTemperature,
                                      currentTemperature: currentTemperature)
        
        if let weather = data.weathers.first, let data = cashedImage.object(forKey: weather.icon as NSString) {
            iconData = data
        }
        let currentInformation = CurrentInformation(currentWeatherIcon: iconData, currentLocationAddress: address)
        
        return CurrentViewModel(currentInformation: currentInformation, temperature: temperature)
    }
    
    private func makeForecastWeather(with data: ForecastWeather) -> [ForecastViewModel] {
        
        var forecastViewModels = [ForecastViewModel]()
        
        data.list.forEach { element in
            let forecastDate: Double = element.timeOfDataCalculation
            let forecastTemperature: Double = element.main.temperature
            let forecastInformation = ForecastInformation(forecastDate: forecastDate, forecastDegree: forecastTemperature)
            var forecastIcon: UIImage = UIImage()
            
            if let icon = element.weather.first?.icon {
                guard let icon = cashedImage.object(forKey: icon as NSString) else {
                    return
                }
                forecastIcon = icon
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

