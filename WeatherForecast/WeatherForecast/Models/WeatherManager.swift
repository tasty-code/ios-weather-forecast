//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by Janine on 11/23/23.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate: AnyObject {
    func showAlertWhenNoAuthorization()
    func updateCollectionViewUI()
    func refreshCollectionViewUI()
}

final class WeatherManager: NSObject {
    private(set) var cacheData: [Endpoint: Decodable] = [:]
    
    private var networkManager: NetworkManager = NetworkManager(session: URLSession(configuration: .default))
    
    weak var delegate: WeatherManagerDelegate?
    
    private let locationManager: CLLocationManager
    
    var longitude: String? {
        return locationManager.location?.coordinate.longitude.description
    }
    var latitude: String? {
        return locationManager.location?.coordinate.latitude.description
    }
    
    private(set) var currentAddress: String?
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    func startLocationUpdate() {
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdate() {
        locationManager.stopUpdatingLocation()
    }
    
    func refreshData() {
        
        fetchWeatherData(endpoint: .forecast, expect: FiveDayForecast.self, completionHandler: self.delegate!.refreshCollectionViewUI)
        fetchWeatherData(endpoint: .weather, expect: CurrentWeather.self, completionHandler: self.delegate!.refreshCollectionViewUI)
    }
    
    // MARK: - private method
    
    private func fetchWeatherData<T: Decodable>(endpoint: Endpoint, expect: T.Type, completionHandler: @escaping () -> Void) {
        guard let latitude = latitude, let longitude = longitude else {
            return
        }
        
        let request = GetRequest(endpoint: endpoint, queryParameters: [URLQueryItem(name: "lat", value: latitude), URLQueryItem(name: "lon", value: longitude), URLQueryItem(name: "units", value: "metric"), URLQueryItem(name: "appid", value: Environment.apiKey)]).makeURLrequest()
        
        // 통신
        networkManager.execute(request, expecting: expect) { result in
            switch result {
            case .success(let success):
                print(success)
                self.cacheData[endpoint] = success
                completionHandler()
                
            case .failure:
                print("모델 객체에 넣기 실패", result)
                break
            }
        }
    }
    
    private func getCurrentAddress() {
        var currentAddress = ""
        
        let geoCoder: CLGeocoder = CLGeocoder()
        
        let locale = Locale(identifier: "Ko-Kr")
        
        guard let location = locationManager.location else { return }
        
        geoCoder.reverseGeocodeLocation(location, preferredLocale:  locale) { placemark, error in
            guard error == nil, let place = placemark?.first else { return }
            
            if let administrativeArea: String = place.administrativeArea { currentAddress.append(administrativeArea + " ") }
            
            if let locality: String = place.locality { currentAddress.append(locality + " ") }
            if let subLocality: String = place.subLocality { currentAddress.append(subLocality + " ") }
                        
            self.currentAddress = currentAddress
        }
    }
    
}

extension WeatherManager: CLLocationManagerDelegate {
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        stopLocationUpdate()
        
        switch manager.authorizationStatus {
        case .restricted, .denied:
            DispatchQueue.main.async {
                self.delegate?.showAlertWhenNoAuthorization()
            }
            
            break
            
        case .notDetermined:
            break
            
        default:
            fetchWeatherData(endpoint: .forecast, expect: FiveDayForecast.self, completionHandler: self.delegate!.updateCollectionViewUI)
//            fetchWeatherData(endpoint: .weather, expect: CurrentWeather.self, completionHandler: self.delegate!.updateCollectionViewUI)
            getCurrentAddress()
            
            break
        }
    }
}
