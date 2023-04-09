//
//  WeatherForecast - WeatherForecastViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class WeatherForecastViewController: UIViewController {

    // MARK: - Properties
    
    var viewModel: WeatherForecastViewModel
    
    // MARK: - Initialization
    
    init(viewModel: WeatherForecastViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.requestWeatherData()
        viewModel.requestForecastData()
        binding()
    }
}

// MARK: - Methods

extension WeatherForecastViewController {
    
    private func binding() {
        
        viewModel.loadWeatherEntity = { [weak self] result in
            switch result {
            case .success(let weatherEntity):
                // ui 업데이트
                print(weatherEntity)
            case .failure(let error):
                print("Error fetching weather data: \(error.localizedDescription)")
            }
        }
        
        viewModel.loadForecastEntity = { [weak self] result in
            switch result {
            case .success(let forecastEnitity):
                // ui 업데이트
                print(forecastEnitity)
            case .failure(let error):
                print("Error fetching forecast data: \(error.localizedDescription)")
            }
        }
    }
}
