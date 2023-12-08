//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/20/23.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation(locationManager: LocationManager?, location: CLLocation)
    func didUpdatePlacemark(locationManager: LocationManager?, placemark: CLPlacemark)
}

final class LocationManager: NSObject, ReverseGeocodable, LocationRequestable {
    enum LocaleType {
        case korea
        
        var identifier: String {
            switch self {
            case .korea: "ko_KR"
            }
        }
    }
    
    private let locationManager: CLLocationManager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func reverseGeocodeLocation(location: CLLocation) {
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: LocaleType.korea.identifier)
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { placemarks, error in
            guard error == nil else { return }
            guard let placemark = placemarks?.last else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didUpdatePlacemark(locationManager: self, placemark: placemark)
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        delegate?.didUpdateLocation(locationManager: self, location: location)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .notDetermined, .denied, .restricted:
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
