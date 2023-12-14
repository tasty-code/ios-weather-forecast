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
    private let forecastDataService = ForecastDataService()
    private let todayDataService = TodayDataService()
    private let iconDataService = IconDataService()
    
    // MARK: Data
    private(set) var today: WeatherToday?
    private(set) var forecast: WeatherForecast?
    var address: String?
    
    init() {
        forecastDataService.delegate = self
        todayDataService.delegate = self
    }
    
    private func storeImageIcon() {
        let group = DispatchGroup()
        forecast?.list.forEach { list in
            let code = list.weather[0].icon
            if ImageFileManager.isExist(forKey: code) { return }
            
            DispatchQueue.global().async(group: group) {
                do {
                    try self.iconDataService.downloadData(type: .icon(code: code))
                } catch {
                    print(error)
                }
            }
        }
        
        group.wait()
    }
    
    func downloadData(with coordinate: CLLocationCoordinate2D) {
        do {
            try todayDataService.downloadData(type: .today(coordinate: coordinate))
            try forecastDataService.downloadData(type: .forecast(coordinate: coordinate))
        } catch {
            print(error)
        }
    }
}

// MARK: - TodayDataServiceDelegate, ForecastDataServiceDelegate

extension WeatherDataManager: TodayDataServiceDelegate, ForecastDataServiceDelegate {
    
    func todayDataService(_ service: TodayDataService, didDownload data: WeatherToday) {
        today = data
        delegate?.updateTodayWeatherView(self, with: data)
    }
    
    func forecastDataService(_ service: ForecastDataService, didDownload data: WeatherForecast) {
        forecast = data
        storeImageIcon()
        delegate?.updateForecastWeatherView(self, with: data)
    }
}
