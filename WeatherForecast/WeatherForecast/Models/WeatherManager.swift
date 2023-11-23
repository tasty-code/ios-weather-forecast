//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by Janine on 11/23/23.
//

import Foundation
import CoreLocation

protocol LocationManagerUIDelegate {
    func showAlertWhenNoAuthorization()
}

final class WeatherManager: NSObject {
    
    var delegate: LocationManagerUIDelegate?
    
    let locationManager: CLLocationManager
    
    var longitude: String? {
        return locationManager.location?.coordinate.longitude.description
    }
    var latitude: String? {
        return locationManager.location?.coordinate.latitude.description
    }
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }

    func start() {
        locationManager.startUpdatingLocation()
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
    }
    
    func fetchWeatherData<T: Decodable>(endpoint: Endpoint, expect: T.Type) {
        guard let latitude = latitude, let longitude = longitude else {
            return
        }
        
        let request = GetRequest(endpoint: endpoint, queryParameters: [URLQueryItem(name: "lat", value: latitude), URLQueryItem(name: "lon", value: longitude), URLQueryItem(name: "appid", value: Environment.apiKey)]).makeURLrequest()
        ServiceManager.shared.execute(request, expecting: expect) { result in
            
            switch result {
            case .success(let success):
                
                // 데이터 확인용
                print(type(of: success))
            case .failure:
                print("모델 객체에 넣기 실패", result)
                break
            }
        }
    }
    
    func getCurrentAddress() {
        var currentAddress = ""
        let geoCoder: CLGeocoder = CLGeocoder()
        
        let locale = Locale(identifier: "Ko-Kr")
        
        guard let location = locationManager.location else { return }
        
        geoCoder.reverseGeocodeLocation(location, preferredLocale:  locale) { (placemark, error) -> Void in
            guard error == nil, let place = placemark?.first else { return }
            
            if let administrativeArea: String = place.administrativeArea { currentAddress.append(administrativeArea + " ") }
            
            if let locality: String = place.locality { currentAddress.append(locality + " ") }
            
            if let subLocality: String = place.subLocality { currentAddress.append(subLocality + " ") }
            
            // 데이터 확인용
            print(currentAddress)
        }
    }
    
}

extension WeatherManager: CLLocationManagerDelegate {
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .restricted, .denied:
            DispatchQueue.main.async {
                self.delegate?.showAlertWhenNoAuthorization()
            }
            break
            
        case .notDetermined:
            break
            
        default:
            fetchWeatherData(endpoint: .forecast, expect: FiveDayForecast.self)
            fetchWeatherData(endpoint: .weather, expect: CurrentWeather.self)
            getCurrentAddress()
            break
        }
    }
}
