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
    
    func requestFetchData(lon: Double, lat: Double) {
        usecase.fetchForecast(lon: lon, lat: lat) { [weak self] forecastEntity in
            self?.loadEntity(forecastEntity)
        }
    }
}
