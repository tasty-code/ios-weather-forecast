//
//  ForecastService.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/03/30.
//

import Foundation

final class ForecastService {
    let repository = ForecastRepository()
    
    var model = ForecastModel()
    
    func fetchForecast(completion: @escaping (ForecastModel) -> Void) {
        repository.fetchForecast { [weak self] entity in
            let model = ForecastModel()
            self?.model = model
            completion(model)
        }
    }
}
