//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by 김진웅 on 11/23/23.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func update(with location: LocationData)
}

final class LocationManager: NSObject {
    weak var delegate: LocationManagerDelegate?
    private let locationManager: CLLocationManager = CLLocationManager()
    private let geoCoder: CLGeocoder = CLGeocoder()
    
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
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print("주소 가져오기 실패: \(error.localizedDescription)")
            }
            
            var addressArray = [String]()
            guard let placemark = placemarks?.first else {
                print("주소를 찾을 수 없습니다.")
                return
            }
            
            guard let address = self?.combineAddress(with: placemark) else { return }
            
            self?.delegate?.update(with: LocationData(coordinate: location.coordinate,
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
        print("위치 업데이트 실패: \(error.localizedDescription)")
    }
}

extension LocationManager {
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
