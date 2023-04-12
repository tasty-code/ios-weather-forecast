//
//  FiveDaysForecastCell.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/04/05.
//

import UIKit

class FiveDaysForecastCell: UICollectionViewCell {
    
    private let weatherIconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let dateLabel = UILabel(systemFontSize: 16, textColor: .white)
    
    private let temperatureLabel = UILabel(systemFontSize: 16, textColor: .white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with fiveDaysForecast: FiveDaysForecastWeatherViewModel.FiveDaysForecast) {
        
        temperatureLabel.text = fiveDaysForecast.temperature.changeWeatherFormat().degree
        dateLabel.text = fiveDaysForecast.date.changeDateFormat()
        weatherIconImage.image = fiveDaysForecast.image
    }
    
    private func setUp() {
        self.contentView.addSubview(weatherIconImage)
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(temperatureLabel)
    }
    
    private func setupConstraints() {
        weatherIconImage.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        weatherIconImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        weatherIconImage.heightAnchor.constraint(equalToConstant: 45).isActive = true
        weatherIconImage.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        temperatureLabel.rightAnchor.constraint(equalTo: weatherIconImage.leftAnchor, constant: -10).isActive = true
        temperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}

