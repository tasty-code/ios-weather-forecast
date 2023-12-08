//
//  WeeklyWeatherCell.swift
//  WeatherForecast
//
//  Created by 김수경 on 2023/12/08.
//

import UIKit

class WeeklyWeatherCell: UICollectionViewCell {
    static let identifier = "WeeklyWeatherCell"
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    func configure() {
        addSubview(dateLabel)
        addSubview(temperatureLabel)
        addSubview(weatherImageView)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor),

            temperatureLabel.topAnchor.constraint(equalTo: topAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: weatherImageView.leadingAnchor),
            
            weatherImageView.topAnchor.constraint(equalTo: topAnchor),
            weatherImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            weatherImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            weatherImageView.widthAnchor.constraint(equalTo: weatherImageView.heightAnchor, multiplier: 1.0)
        ])
    }
}
 
