//
//  LocationDataManager.swift
//  WeatherForecast
//
//  Created by 김예준 on 11/23/23.
//

import CoreLocation

final class LocationDataManager : NSObject {
    private var locationManager = CLLocationManager()
    weak var locationDelegate: LocationDataManagerDelegate?
    
    override init() {
        super.init()
        // 절전 기능 활성화
        locationManager.distanceFilter = CLLocationDistanceMax
        locationManager.allowsBackgroundLocationUpdates = false
        
        locationManager.delegate = self
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationDataManager: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .authorizedWhenInUse:
                manager.startUpdatingLocation()
                break
            case .restricted, .denied:
                // showRequestLocationServiceAlert()
                // disableLocationFeatures()
                break
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
                break
            default:
                break
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            locationDelegate?.location(self, didLoad: coordinate)
            lookUpCurrentAddress(completionHandler: viewCurrentAddress)
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
        if let lastLocation = locationManager.location {
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(lastLocation) { (placemarks, error) in
                if error == nil {
                    guard let placemarks else { return }
                    let firstLocation = placemarks[0]
                    completionHandler(firstLocation)
                } else {
                    completionHandler(nil)
                }
            }
        } else {
            completionHandler(nil)
        }
    }
    
    private func viewCurrentAddress(placemark: CLPlacemark?) {
        if let placemark {
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
        } else {
            print("location 가져오기 실패")
        }
    }
}
