//
//  ForecastViewModel.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/03/30.
//

import Foundation

final class ForecastViewModel {
    
    private let usecase: ForecastUseCase
    var loadEntity: ((ForecastEntity) -> Void)!
    
    init(usecase: ForecastUseCase) {
        self.usecase = usecase
    }
}

extension ForecastViewModel {
    
    func requestFetchData(lat: Double, lon: Double) {
        usecase.fetchForecast(lat: lat, lon: lon) { [weak self] forecastEntity in
            self?.loadEntity(forecastEntity)
        }
    }
}
