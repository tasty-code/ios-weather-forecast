//
//  WeatherRepository.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/03/30.
//

import Foundation

final class WeatherRepository: WeatherRepositoryInterface {
    
    private let service: NetworkService
    
    init(service: NetworkService) {
        self.service = service
    }
}

extension WeatherRepository {
    func fetchWeather(lat: String, lon: String, completion: @escaping (WeatherEntitiy) -> Void) {

        service.fetchWeather(lat: lat, lon: lon) { result in
            switch result {
            case .success(let weatherDTO):
                completion(weatherDTO.toDomain())
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
