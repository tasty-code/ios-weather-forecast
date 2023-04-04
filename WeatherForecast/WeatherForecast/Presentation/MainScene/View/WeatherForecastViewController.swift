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
        binding()
    }
}

// MARK: - Methods

extension WeatherForecastViewController {
    
    private func binding() {

        viewModel.loadWeatherEntity = { [weak self] weatherEntity in
            // ui 업데이트
            print(weatherEntity)
        }

        viewModel.loadForecastEntity = { [weak self] forecastEnitity in
            // ui 업데이트
            print(forecastEnitity)
        }
    }
}
