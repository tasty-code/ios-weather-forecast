//
//  CurrentWeatherCell.swift
//  WeatherForecast
//
//  Created by 송선진 on 2023/04/05.
//

import UIKit

final class CurrentWeatherCell: UICollectionViewListCell {
    
    var currentWeather: CurrentWeatherViewModel.CurrentWeather?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        guard let currentWeather = currentWeather else { return }
        
        let currentTemperatureText = currentWeather.temperatures.averageTemperature.description
        
        var configuration = configureAttribute(addressAndTemperatureText: currentWeather.description, currentTemperatureText: currentTemperatureText)
        configuration.image = currentWeather.image
        
        contentConfiguration = configuration
    }
    
    private func configureAttribute(addressAndTemperatureText: String, currentTemperatureText: String) -> UIListContentConfiguration {
        
        var configuration = UIListContentConfiguration.subtitleCell()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        let addressAndTemperatureTextAttributes: [NSAttributedString.Key: Any] = [
            .font : UIFont.systemFont(ofSize: 13),
            .paragraphStyle : paragraphStyle,
        ]
        
        configuration.attributedText = NSAttributedString(string: addressAndTemperatureText,attributes: addressAndTemperatureTextAttributes)
        configuration.textProperties.color = .white
        
        let currentTemperatureTextAttribtues: [NSAttributedString.Key: Any] = [
            .font : UIFont.systemFont(ofSize: 30, weight: .semibold)
        ]
        
        configuration.secondaryAttributedText = NSAttributedString(string: currentTemperatureText,attributes: currentTemperatureTextAttribtues)
        configuration.secondaryTextProperties.color = .white
        configuration.textToSecondaryTextVerticalPadding = 10
        
        return configuration
    }
}
