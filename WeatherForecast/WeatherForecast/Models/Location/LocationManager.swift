//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by 김진웅 on 11/23/23.
//

import Foundation
import CoreLocation

protocol LocationUpdateDelegate: AnyObject {
    func updateWeather(with data: LocationData)
    func didFailedUpdateLocaion(error: Error)
}

final class LocationManager: NSObject {
    weak var delegate: LocationUpdateDelegate?
    private let locationManager: CLLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                self?.delegate?.didFailedUpdateLocaion(error: error)
                return
            }
        
            guard let placemark = placemarks?.last else { return }
            
            guard let address = self?.combineAddress(with: placemark) else { return }
            
            self?.delegate?.updateWeather(with: LocationData(coordinate: location.coordinate,
                                                      address: address))
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation() 
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailedUpdateLocaion(error: error)
    }
}

extension LocationManager {
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    private func combineAddress(with placemark: CLPlacemark) -> String {
        var temp = [String]()
        
        if let administrativeArea = placemark.administrativeArea {
            temp.append(administrativeArea)
        }
        
        if let subAdministrativeArea = placemark.subAdministrativeArea {
            temp.append(subAdministrativeArea)
        }
        
        if let subLocalty = placemark.subLocality {
            temp.append(subLocalty)
        }
        
        return temp.joined(separator: " ")
    }
}
