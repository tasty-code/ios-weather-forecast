//
//  WeatherViewModelDelegate.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/04/05.
//

import Foundation

protocol WeatherViewModelDelegate: AnyObject {
    
    func weatherViewModelDidFinishSetUp(_ viewModel: WeatherViewModel)
}
