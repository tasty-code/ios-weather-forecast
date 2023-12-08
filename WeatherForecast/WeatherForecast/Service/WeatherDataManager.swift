//
//  WeatherDataManager.swift
//  WeatherForecast
//
//  Created by 김예준 on 12/8/23.
//

import Foundation
import UIKit

final class WeatherDataManager {
    weak var delegate: WeatherDataManagerDelegate?
    
    private let iconDataService = IconDataService()
    private let networkManager = WeatherNetworkManager()
    
    let forecastDataService = ForecastDataService()
    let todayDataService = TodayDataService()
    var today: WeatherToday?
    var forecast: WeatherForecast?
    
    init() {
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
