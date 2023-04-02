//
//  ForecastRepository.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/03/30.
//

import Foundation

final class ForecastRepository {

    private let service: NetworkService
    
    init(service: NetworkService) {
        self.service = service
    }
    
    // dto -> entity toDomain 호출을 repository layer 에서 하겠음
    func fetchForecast(lat: String, lon: String, completion: @escaping (ForecastEntity) -> Void) {

        service.fetchForecast(lat: lat, lon: lon) { [weak self] result in
            switch result {
            case .success(let dto):
                completion(dto.toDomain())
//            case .success(let forecastDTO):
//                let forecastEntity = forecastDTO.map { $0.toDomain() }
//                completion(forecastEntity)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
