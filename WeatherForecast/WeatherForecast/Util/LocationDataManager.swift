//
//  LocationDataManager.swift
//  WeatherForecast
//
//  Created by 김예준 on 11/23/23.
//

import CoreLocation

// TODO: coreLoacation 을 통해 주소 가져오기

final class LocationDataManager : NSObject {
    private var locationManager = CLLocationManager()
    weak var locationDelegate: LocationDelegate?
    
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
    
    // 사용자의 위치를 성공적으로 가져왔을 때 호출
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            print(coordinate)
            locationDelegate?.location(self, didLoad: coordinate)
            lookUpCurrentLocation(completionHandler: viewCurrentAddress)
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("GPS 사용이 불가한 지역에 있는 등 위치 정보를 가져오지 못했습니다.")
    }
}

extension LocationDataManager {
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void ) {
        if let lastLocation = locationManager.location {
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(lastLocation) { (placemrks, error) in
                if error == nil {
                    let firstLocation = placemrks?[0]
                    completionHandler(firstLocation)
                } else {
                    completionHandler(nil)
                }
            }
        } else {
            completionHandler(nil)
        }
    }
    
    func viewCurrentAddress(placemarks: CLPlacemark?) {
        if let placemarks = placemarks {
            let address = "\(placemarks.country!) \(placemarks.administrativeArea!) \(placemarks.locality!) \(placemarks.subLocality!) \(placemarks.thoroughfare!) \(placemarks.subThoroughfare!)"
            print(address)
        }
    }
}
