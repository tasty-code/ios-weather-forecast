//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class ViewController: UIViewController {
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        default:
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }

        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let coordinate = CurrentCoordinate(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        
        Task {
            let _ = try await WeatherParser<CurrentWeatherComponents>.parse(at: coordinate)
            let _ = try await WeatherParser<ForecastWeatherComponents>.parse(at: coordinate)
            let placemark = try await geocoder.reverseGeocodeLocation(location)
            let address = placemark.description.components(separatedBy: ", ")[1]
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
