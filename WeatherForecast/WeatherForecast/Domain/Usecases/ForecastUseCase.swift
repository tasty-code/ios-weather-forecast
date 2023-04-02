//
//  ForecastUseCase.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/03/30.
//

import Foundation

final class ForecastUseCase {
  
    private let repository: ForecastRepositoryInterface
  
    init(repository: ForecastRepositoryInterface) {
        self.repository = repository
    }
    
    func fetchForecast() {
        self.repository.fetchForecast()
    }
}
