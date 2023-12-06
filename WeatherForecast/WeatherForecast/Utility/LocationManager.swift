//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by BOMBSGIE on 2023/11/27.
//

import CoreLocation

final class LocationManager: NSObject {
    let manager: CLLocationManager = CLLocationManager()
    weak var currentLocationManager: CurrentLocationManagable?
    weak var weatherDelgate: WeatherUpdateDelegate?
    
    override init() {
        super.init()
        self.manager.delegate = self
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            currentLocationManager?.defaultLocationInfo()
            weatherDelgate?.fetchWeather()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let placemark = placemarks?.last else { return }
            self?.currentLocationManager?.updateLocationInfo(with: placemark)
            self?.weatherDelgate?.fetchWeather()
        }
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let clError = error as? CLError else { return }
        if clError.code == .denied {
            print("위치 서비스 권한이 없습니다.")
        }
    }
}

