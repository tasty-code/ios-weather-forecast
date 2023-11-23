//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ViewController: UIViewController {
    @IBOutlet weak var weatherLabel: UILabel!
    
    private let dataService = WeatherForecastDataService()
    private let locationManager = LocationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLocationLabel()
    }
    
    private func configureLocationLabel() {
        guard let coordinates = locationManager.fetchCurrentLocatedCoordinates() else { return print("Failed to fetch current located coordinates") }
        
        dataService.fetchData(.weather, coordinate: coordinates)
        
        guard let model = dataService.readModel() else { return print("Failed to read model from DataService") }
        
        guard let weatherModel = model as? WeatherModel else { return print("Failed to downcast from model") }
        
        if let name = weatherModel.name {
            weatherLabel.text = name
        }
    }
}

