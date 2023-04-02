//
//  ForecastUseCase.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/03/30.
//

import Foundation

final class ForecastUseCase {
  
    private let repository: ForecastRepositoryInterface
    
//    var loadEntity: ((ForecastEntity) -> Void)!
  
    init(repository: ForecastRepositoryInterface) {
        self.repository = repository
    }
}

extension ForecastUseCase {
    
    func fetchForecast(lon: Double, lat: Double, completion: @escaping(ForecastEntity) -> Void) {
        let forecastEntity = self.repository.fetchForecast()
        completion(forecastEntity)
//        loadEntity(forecastEntity)
    }
}
