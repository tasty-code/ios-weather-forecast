//
//  WeatherForecastRepository.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/04/03.
//

import Foundation

final class WeatherForecastRepository: WeatherForecastRepositoryInterface {
    
    private let service: NetworkService
    
    init(service: NetworkService) {
        self.service = service
    }
}

extension WeatherForecastRepository {
    
    func fetchWeather(lat: String, lon: String, completion: @escaping (WeatherEntity) -> Void) {

        service.fetchWeather(lat: lat, lon: lon) { result in
            switch result {
            case .success(let weatherDTO):
                completion(weatherDTO.toDomain())
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchForecast(lat: String, lon: String, completion: @escaping (ForecastEntity) -> Void) {

        service.fetchForecast(lat: lat, lon: lon) { result in
            switch result {
            case .success(let forecastDTO):
                completion(forecastDTO.toDomain())
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
