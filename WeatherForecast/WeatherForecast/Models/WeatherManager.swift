//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by Janine on 11/23/23.
//

import Foundation
import CoreLocation

final class WeatherManager: NSObject {

    var longitude: Double?
    var latitude: Double?
    
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
                NotificationCenter.default.post(name: Notification.Name("WeatherNetworkChanged"), object: nil)
                self.iconFetch()
            }
        }
    }
}

// MARK: - Public Method(Location)

extension WeatherManager {
    func startLocationUpdate() {
        locationManager.startUpdatingLocation()
        
        guard let lat = locationManager.location?.coordinate.latitude.description,
              let lon = locationManager.location?.coordinate.longitude.description,
              let latitude = Double(lat),
              let longitude = Double(lon) else { return }
        
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func stopLocationUpdate() {
        locationManager.stopUpdatingLocation()
    }
    
    func setCurrentAddress() {
        var currentAddress = ""
        
        let geoCoder: CLGeocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-Kr")
        
        guard let latitude = latitude, let longitude = longitude else { return }
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
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
    func changeLocation(lat: Double, lon: Double) {
        latitude = lat
        longitude = lon
        refreshData()
    }
    
    func rejected() {
        NotificationCenter.default.post(name: Notification.Name("NoAuthorization"), object: nil)
    }
    
    func permitted(_ completion: @escaping () -> Void) {
        setCurrentAddress()
        
        guard let latitude = latitude, let longitude = longitude else { return }
        
        guard let currentWeatherRequest = GetRequest(endpointType: .weather, queryParameters: .weatherService(latitude: "\(latitude)", longitude: "\(longitude)")).makeURLrequest(),
              let forecastRequest = GetRequest(endpointType: .forecast, queryParameters: .weatherService(latitude: "\(latitude)", longitude: "\(longitude)")).makeURLrequest() else { return }
        
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
            self.iconFetch()
            NotificationCenter.default.post(name: Notification.Name("WeatherDataRefreshed"), object: nil)
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
        
        NotificationCenter.default.post(name: Notification.Name("WeatherNetworkChanged"), object: nil)
//        self.delegate?.updateWeatherDisplay()
    }
}
