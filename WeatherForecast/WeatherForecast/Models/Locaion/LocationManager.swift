//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by 김진웅 on 11/23/23.
//

import Foundation
import CoreLocation

protocol UpdatedLocationDelegate: AnyObject {
    func update(with data: LocationData)
}

final class LocationManager: NSObject {
    weak var delegate: UpdatedLocationDelegate?
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
                print("주소 가져오기 실패: \(error.localizedDescription)")
            }
            
            guard let placemark = placemarks?.last else {
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
