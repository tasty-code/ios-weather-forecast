//
//  WeatherData.swift
//  WeatherForecast
//
//  Created by Blu on 2023/03/28.
//

import Foundation
import UIKit

struct WeatherData {
    let dataTime: String?
    var iconImage: UIImage?
    let iconCode, temperature, minimumTemperature, maximumTemperature: String
    
    init(current: CurrentWeatherComponents) {
        self.dataTime = nil
        self.iconCode = current.weather[0].icon
        self.temperature = String(temperature: current.numericalInformation.temperature)
        self.minimumTemperature = String(temperature: current.numericalInformation.minimumTemperature)
        self.maximumTemperature = String(temperature: current.numericalInformation.maximumTemperature)
    }
    
    init(forecast: WeatherInformation) {
        self.dataTime = String(utcTime: forecast.dataTime)
        self.iconCode = forecast.weather[0].icon
        self.temperature = String(temperature: forecast.numericalInformation.temperature)
        self.minimumTemperature = String(temperature: forecast.numericalInformation.minimumTemperature)
        self.maximumTemperature = String(temperature: forecast.numericalInformation.maximumTemperature)
    }
    
    func convertToImage(_ completion: @escaping (UIImage?) -> Void) async throws {
        let image = try await WeatherParser.parseIcon(with: iconCode)
        completion(image)
    }
    
    func temperatureString() -> String {
        return "최저 \(minimumTemperature) 최고 \(maximumTemperature)"
    }
}
