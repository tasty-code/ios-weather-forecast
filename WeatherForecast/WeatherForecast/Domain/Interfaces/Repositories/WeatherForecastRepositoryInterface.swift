//
//  WeatherForecastRepositoryInterface.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/04/03.
//

import Foundation

protocol WeatherForecastRepositoryInterface: WeatherRepositoryInterface, ForecastRepositoryInterface { }

protocol WeatherRepositoryInterface {
    func fetchWeather(lat: String, lon: String, completion: @escaping (Result<WeatherResponseDTO, NetworkError>) -> Void)
}

protocol ForecastRepositoryInterface {
    func fetchForecast(lat: String, lon: String, completion: @escaping (Result<ForecastResponseDTO, NetworkError>) -> Void)
}
