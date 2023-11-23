//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    var locationManager: CLLocationManager?
    var longitude: String? {
        return locationManager?.location?.coordinate.longitude.description
    }
    var latitude: String? {
        return locationManager?.location?.coordinate.latitude.description
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startUpdatingLocation()
        
        locationManager?.delegate = self
    }
    
    func fetchWeatherData<T: Decodable>(endpoint: Endpoint, expect: T.Type) {
        guard let latitude = latitude, let longitude = longitude else {
            return
        }
        
        let request = GetRequest(endpoint: endpoint, queryParameters: [URLQueryItem(name: "lat", value: latitude), URLQueryItem(name: "lon", value: longitude), URLQueryItem(name: "appid", value: Environment.apiKey)]).makeURLrequest()
        ServiceManager.shared.execute(request, expecting: expect) {
            
            // 데이터 확인용
            print(">>> ✅ \(endpoint.rawValue) :",$0.self)
            
        }
    }
    
    func showAlertWhenNoAuthorization() {
        let alert = UIAlertController(title: nil, message: "설정>앱>위치에서 변경 가능", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "설정으로 이동", style: .default)  { _ in
            guard let url = URL(string:UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        }
        let noAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: CLLocationManagerDelegate {
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .restricted, .denied:
            showAlertWhenNoAuthorization()
            break
            
        case .notDetermined:
            break
            
        default:
            fetchWeatherData(endpoint: .forecast, expect: FiveDayForecast.self)
            fetchWeatherData(endpoint: .weather, expect: CurrentWeather.self)
            break
        }
    }
}
