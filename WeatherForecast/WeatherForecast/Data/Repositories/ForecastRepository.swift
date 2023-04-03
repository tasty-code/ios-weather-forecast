//
//  ForecastRepository.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/03/30.
//

import Foundation

final class ForecastRepository: ForecastRepositoryInterface {
    
    private let service: NetworkService
    
    init(service: NetworkService) {
        self.service = service
    }
}

extension ForecastRepository {
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
