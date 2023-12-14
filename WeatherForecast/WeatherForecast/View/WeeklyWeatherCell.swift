//
//  WeeklyWeatherCell.swift
//  WeatherForecast
//
//  Created by 김수경 on 2023/12/08.
//

import UIKit

final class WeeklyWeatherCell: UICollectionViewCell, ReuseIdentifiable {
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var weatherImageView: UIImageView = {
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
    
    func updateUI(date: String, temperature: String, image: UIImage?) {
        dateLabel.text = date
        temperatureLabel.text = temperature
        weatherImageView.image = image
    }
}
