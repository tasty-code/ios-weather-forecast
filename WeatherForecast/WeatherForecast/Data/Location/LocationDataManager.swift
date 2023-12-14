//
//  LocationDataManager.swift
//  WeatherForecast
//
//  Created by 김예준 on 11/23/23.
//

import CoreLocation
import UIKit

final class LocationDataManager : NSObject {
    private var locationManager = CLLocationManager()
    weak var locationDelegate: LocationDataManagerDelegate?
    
    override init() {
        super.init()
        
        configurePowerSaving()
        locationManager.delegate = self
    }
    
    private func configurePowerSaving() {
        locationManager.distanceFilter = CLLocationDistanceMax
        locationManager.allowsBackgroundLocationUpdates = false
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationDataManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .authorizedWhenInUse:
                manager.startUpdatingLocation()
            case .restricted, .denied:
                locationDelegate?.viewRequestLocationSettingAlert()
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            default:
                break
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationDelegate else { return }
        if let coordinate = locations.last?.coordinate {
            locationDelegate.location(self, didLoadCoordinate: coordinate)
            lookUpCurrentAddress { placemark in
                locationDelegate.loaction(self, didCompletePlacemark: placemark)
            }
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("GPS 사용이 불가한 지역에 있는 등 위치 정보를 가져오지 못했습니다.")
    }
}

// MARK: - Get Address

extension LocationDataManager {
    private func lookUpCurrentAddress(completionHandler: @escaping (CLPlacemark?) -> Void ) {
        guard let lastLocation = locationManager.location else { return completionHandler(nil) }
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(lastLocation) { (placemarks, error) in
            if error == nil {
                guard let placemarks else { return completionHandler(nil) }
                let firstLocation = placemarks[0]
                completionHandler(firstLocation)
            } else {
                completionHandler(nil)
            }
        }
    }
}
