//
//  ForecastRepositoryInterface.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/03/30.
//

import Foundation

protocol ForecastRepositoryInterface {
//    func fetchForecast() -> ForecastEntity
    func fetchForecast(lat: String, lon: String, completion: @escaping (ForecastEntity) -> Void)
}
