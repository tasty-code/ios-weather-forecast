//
//  WeatherDataManager.swift
//  WeatherForecast
//
//  Created by 김예준 on 12/8/23.
//

import UIKit
import CoreLocation
import Foundation

final class WeatherDataManager {
    weak var delegate: WeatherDataManagerDelegate?
    
    // MARK: Private property
    private let locationDataManager = LocationDataManager()
    private let forecastDataService = ForecastDataService()
    private let todayDataService = TodayDataService()
    private let iconDataService = IconDataService()
    
    // MARK: Data
    private(set) var today: WeatherToday?
    private(set) var forecast: WeatherForecast?
    private(set) var address: String?
    
    init() {
        locationDataManager.locationDelegate = self
        forecastDataService.delegate = self
        todayDataService.delegate = self
        iconDataService.delegate = self
    }
    
    private func setIconCache() {
        let group = DispatchGroup()
        forecast?.list.forEach { list in
            let code = list.weather[0].icon
            DispatchQueue.global().async(group: group) {
                self.iconDataService.downloadData(type: .icon(code: code))
            }
        }
        
        group.wait()
    }
}

// MARK: - ForecastDataServiceDelegate, TodayDataServiceDelegate, IconDataServiceDelegate

extension WeatherDataManager: ForecastDataServiceDelegate, TodayDataServiceDelegate, IconDataServiceDelegate {
    func forecastDataService(_ service: ForecastDataService, didDownload data: WeatherForecast) {
        forecast = data
        setIconCache()
    }
    
    func todayDataService(_ service: TodayDataService, didDownload data: WeatherToday) {
        today = data
        delegate?.completedLoadData(self)
    }
    
    func didCompleteLoad(_ service: IconDataService) {
        delegate?.completedLoadData(self)
    }
}

// MARK: - LocationDataManagerDelegate

extension WeatherDataManager: LocationDataManagerDelegate {
    
    func location(_ manager: LocationDataManager, didLoadCoordinate coordinate: CLLocationCoordinate2D) {
        forecastDataService.downloadData(type: .forecast(coordinate: coordinate))
        todayDataService.downloadData(type: .today(coordinate: coordinate))
    }
    
    func loaction(_ manager: LocationDataManager, didCompletePlcamark placemark: CLPlacemark?) {
        guard let placemark else {
            print("can't look up current address")
            return
        }
        
        address = "\(placemark.locality ?? "") \(placemark.subLocality ?? "")"
    }
    
    func notifyDeniedAuthorization() {
        delegate?.viewRequestLocationSettingAlert()
    }
}
