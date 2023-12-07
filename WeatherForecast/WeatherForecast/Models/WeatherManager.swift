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
    func updateWeatherDisplay()
    func refreshWeatherDisplay()
}

final class WeatherManager: NSObject {
    
    weak var delegate: WeatherManagerDelegate?
    
    var longitude: String? {
        return locationManager.location?.coordinate.longitude.description
    }
    
    var latitude: String? {
        return locationManager.location?.coordinate.latitude.description
    }
    
    // MARK: - Private Property
    
    private let locationManager: CLLocationManager
    private(set) var currentAddress: String?
    
    private(set) var iconService: IconService = IconService()
    
    private(set) var cacheData: [Endpoint: Decodable] = [:]
    
    private let networkManager = NetworkManager()
    
    // MARK: - Initialize
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        startLocationUpdate()
        
        locationManager.delegate = self
    }
}

// MARK: - CLLocation Delegate

extension WeatherManager: CLLocationManagerDelegate {
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        stopLocationUpdate()
        
        switch manager.authorizationStatus {
        case .restricted, .denied:
            self.rejected()
        case .notDetermined:
            break
        default:
            self.permitted {
                self.delegate?.updateWeatherDisplay()
                self.iconFetch()
            }
        }
    }
}

// MARK: - Public Method(Location)

extension WeatherManager {
    func startLocationUpdate() {
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdate() {
        locationManager.stopUpdatingLocation()
    }
    
    func setCurrentAddress() {
        var currentAddress = ""
        
        let geoCoder: CLGeocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-Kr")
        
        guard let location = locationManager.location else { return }
        
        geoCoder.reverseGeocodeLocation(location, preferredLocale:  locale) { placemark, error in
            guard error == nil, let place = placemark?.first else { return }
            
            if let locality: String = place.locality { currentAddress.append(locality + " ") }
            if let subLocality: String = place.subLocality { currentAddress.append(subLocality) }
            
            self.currentAddress = currentAddress
        }
    }
}

// MARK: - Public Method(Data Fetching)

extension WeatherManager {
    func rejected() {
        self.delegate?.showAlertWhenNoAuthorization()
    }
    
    func permitted(_ completion: @escaping () -> Void) {
        setCurrentAddress()
        
        guard let latitude = latitude, let longitude = longitude else { return }
        
        guard let currentWeatherRequest = GetRequest(endpointType: .weather, queryParameters: .weatherService(latitude: latitude, longitude: longitude)).makeURLrequest(),
              let forecastRequest = GetRequest(endpointType: .forecast, queryParameters: .weatherService(latitude: latitude, longitude: longitude)).makeURLrequest() else { return }
        
        networkManager.execute(currentWeatherRequest, expecting: CurrentWeather.self) { data in
            switch data {
            case .success(let success):
                self.cacheData[.weather] = success
            case .failure:
                print("forecast weather error")
                break
            }
        }
        
        networkManager.execute(forecastRequest, expecting: FiveDayForecast.self) { data in
            switch data {
            case .success(let success):
                self.cacheData[.forecast] = success
                completion()
            case .failure:
                print("forecast weather error")
                break
            }
        }
    }
    
    func refreshData() {
        self.permitted {
            self.delegate?.refreshWeatherDisplay()
            self.iconFetch()
        }
    }
    
    private func iconFetch() {
        var list: [String] = []
        
        let weatherData = self.cacheData[.weather] as! CurrentWeather
        list += weatherData.weather.compactMap { item in
            return item.icon
        }
        
        let forecastData = self.cacheData[.forecast] as! FiveDayForecast
        list += forecastData.list.compactMap { item in
            return item.weather.first?.icon
        }
        
        let group = DispatchGroup()
        
        list.forEach { iconId in
            self.iconService.fetchIcon(iconId: iconId, group: group)
        }
            
        group.wait()
        self.delegate?.updateWeatherDisplay()
    }
}
