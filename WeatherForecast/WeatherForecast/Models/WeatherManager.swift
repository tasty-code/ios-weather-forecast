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
    func updateCollectionView()
    func refreshCollectionView()
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
    
    private lazy var currentWeatherService: CurrentWeatherService? = {
        guard let latitude = latitude, let longitude = longitude else { return nil }
        
        return CurrentWeatherService(latitude: latitude, longitude: longitude)
    }()
    
    private lazy var forecastService: ForecastWeatherService? = {
        guard let latitude = latitude, let longitude = longitude else { return nil }
        
        return ForecastWeatherService(latitude: latitude, longitude: longitude)
    }()
    
    private(set) lazy var iconService: IconService = IconService()
    
    private(set) var cacheData: [Endpoint: Decodable] = [:]
    
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
                if self.currentWeatherService!.isNetworkingDone && self.forecastService!.isNetworkingDone {
                    self.iconFetch()
                    self.delegate?.updateCollectionView()
                }
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
        
        guard let currentWeatherService = currentWeatherService,
              let forecastService = forecastService else { return }
        
        currentWeatherService.fetcher({ data in
            self.cacheData[.weather] = data
            completion()
//            guard let iconId = data.weather.first?.icon else { return }
//            
//            self.iconService.fetcher(iconId: iconId) {
//                completion()
//            }
        })
        
        forecastService.fetcher({ data in
            self.cacheData[.forecast] = data
            completion()
//            let list = data.list.compactMap { item in
//                return item.weather.first?.icon
//            }
//            
//            list.forEach { iconId in
//                self.iconService.fetcher(iconId: iconId) {
//                    completion()
//                }
//            }
        })
    }
    
    func refreshData() {
        self.permitted {
            if self.currentWeatherService!.isNetworkingDone && self.forecastService!.isNetworkingDone {
                self.iconFetch()
                self.delegate?.refreshCollectionView()
            }
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
            DispatchQueue.global().async(group: group) {
                self.iconService.fetcher(iconId: iconId)
            }
        }

        group.wait()
    }
}
