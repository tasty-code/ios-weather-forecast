//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation
final class WeatherViewController: UIViewController {
    private let networkManager = WeatherNetworkManager()
    private let locationDataManager = LocationDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationDataManager.locationDelegate = self
    }
}

// MARK: - LocationDataManagerDelegate

extension WeatherViewController: LocationDataManagerDelegate {
    
    func location(_ manager: LocationDataManager, didLoad coordinate: CLLocationCoordinate2D) {
        networkManager.loadWeatherData(type: WeatherType.weatherToday, coord: coordinate)
    }
    
    func viewCurrentAddress(placemark: CLPlacemark?) {
        guard let placemark else {
            print("can't look up current address")
            return
        }
        
        if
            let country = placemark.country,
            let administrativeArea = placemark.administrativeArea,
            let locality = placemark.locality,
            let subLocality = placemark.subLocality,
            let thoroughfare = placemark.thoroughfare,
            let subThoroughfare = placemark.subThoroughfare
        {
            let address = "\(country) \(administrativeArea) \(locality) \(subLocality) \(thoroughfare) \(subThoroughfare)"
            print(address)
        }
    }
}
