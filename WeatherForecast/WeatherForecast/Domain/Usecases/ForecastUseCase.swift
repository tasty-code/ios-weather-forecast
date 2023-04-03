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
}

extension ForecastUseCase {
    
    func fetchForecast(lon: Double, lat: Double, completion: @escaping(ForecastEntity) -> Void) {
        guard let lat = lat.doubleToString(),
              let lon = lon.doubleToString() else { return }
        _ = self.repository.fetchForecast(lat: lat, lon: lon) { forecastEntity in
            completion(forecastEntity)
        }        
    }
}
