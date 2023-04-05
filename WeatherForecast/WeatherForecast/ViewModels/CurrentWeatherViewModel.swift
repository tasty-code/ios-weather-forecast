//
//  CurrentWeatherViewModel.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/31.
//

import UIKit
import CoreLocation

final class CurrentWeatherViewModel {
    
    weak var delegate: CurrentWeatherViewModelDelegate?
    
    struct CurrentWeather {
        let image: UIImage?
        let address: String
        let temperatures: Temperature
    }
    
    func fetchCurrentAddress(locationManager: CoreLocationManager,
                            location: CLLocation,
                            completion: @escaping (String) -> Void
    ) {
        locationManager.changeGeocoder(location: location) { place in
            
            guard let locality = place?.locality, let subLocality = place?.subLocality else { return }
            let address = "\(locality) \(subLocality)"
            completion(address)
        }
    }
    
    func fetchCurrentInformation(weatherNetworkDispatcher: WeatherNetworkDispatcher,
                                coordinate: Coordinate,
                                location: CLLocation,
                                address: String,
                                completion: @escaping (String, CurrentWeatherDTO) -> Void
    ) {
        weatherNetworkDispatcher.requestWeatherInformation(of: .currentWeather, in: coordinate) { data in
            
            guard let weatherData = data as? CurrentWeatherDTO else { return }
            guard let icon = weatherData.weather.first?.icon else { return }
            
            completion(icon, weatherData)
        }
    }
    
    func fetchCurrentImage(weatherNetworkDispatcher: WeatherNetworkDispatcher,
                          iconString: String,
                          address: String,
                          weatherData: CurrentWeatherDTO
    ) {
        weatherNetworkDispatcher.requestWeatherImage(icon: iconString) { weatherImage in
            
            let currentWeather = CurrentWeather(image: weatherImage, address: address, temperatures: weatherData.temperature)
            self.delegate?.currentWeatherViewModel(self, didCreateModelObject: currentWeather)
        }
    }
}

