//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    private lazy var dataService = WeatherForecastDataService(dataServiceDelegate: self)
    private let locationManager: LocationManager = LocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
    }
}

// MARK: DataServiceDelegate Conformation
extension ViewController: DataServiceDelegate {
    func notifyModelDidUpdate(dataService: WeatherForecastDataService, model: Decodable?) {
        
    }
    
    func notifyPlacemarkDidUpdate(dataService: WeatherForecastDataService, currentPlacemark: CLPlacemark?) {
        guard let placemark = currentPlacemark else { return }
        
        var fullLocality: [String] = []
        
        if let locality = placemark.locality {
            fullLocality.append(locality)
        }
        
        if let sublocality = placemark.subLocality {
            fullLocality.append(sublocality)
        }
        
        label.text = fullLocality.joined(separator: " ")
    }
}

// MARK: StartLocationServiceDelegate Conformation
extension ViewController: LocationManagerDelegate {
    func didUpdateLocation(locationManager: LocationManager, location: CLLocation) {
        dataService.fetchData(.weather, location: location)
    }
}
