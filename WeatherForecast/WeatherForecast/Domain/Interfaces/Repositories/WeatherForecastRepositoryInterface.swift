//
//  WeatherForecastRepositoryInterface.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/04/03.
//

import Foundation

protocol WeatherForecastRepositoryInterface: WeatherRepositoryInterface, ForecastRepositoryInterface { }

protocol WeatherRepositoryInterface {
    func fetchWeather(lat: String, lon: String, completion: @escaping(WeatherEntity) -> Void)
}

protocol ForecastRepositoryInterface {
    func fetchForecast(lat: String, lon: String, completion: @escaping (ForecastEntity) -> Void)
}
