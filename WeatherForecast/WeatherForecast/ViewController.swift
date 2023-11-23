//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ViewController: UIViewController {
    @IBOutlet weak var weatherLabel: UILabel!
    
    private lazy var dataService = WeatherForecastDataService(dataServiceDelegate: self)
    private let locationManager = LocationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func updateCurrentTemp(_ sender: UIButton) {
        configureLocationLabel()
    }
    
    private func configureLocationLabel() {
        guard let coordinates = locationManager.fetchCurrentLocatedCoordinates() else { return print("Failed to fetch current located coordinates") }
        
        dataService.fetchData(.weather, coordinate: coordinates)
    }
}

// MARK: DataServiceDelegate Conformation
extension ViewController: DataServiceDelegate {
    func notifyModelDidUpdate(dataService: WeatherForecastDataService, model: Decodable?) {
        guard let weatherModel = model as? WeatherModel else { return print("Failed to downcast from model") }
        
        if let temp = weatherModel.main?.temp {
            weatherLabel.text = "\(temp)"
        }
    }
}

