//
//  LocationDataManager.swift
//  WeatherForecast
//
//  Created by 김예준 on 11/23/23.
//

import CoreLocation

final class LocationDataManager : NSObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        // 절전 기능 활성화
        locationManager.distanceFilter = CLLocationDistanceMax
        locationManager.allowsBackgroundLocationUpdates = false
        
        locationManager.delegate = self
    }
    
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
            
        }
    }
}

extension LocationDataManager {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            print(coordinate)
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("GPS 사용이 불가한 지역에 있는 등 위치 정보를 가져오지 못했습니다.")
    }
    
}
