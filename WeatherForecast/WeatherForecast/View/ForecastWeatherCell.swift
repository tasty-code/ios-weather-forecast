//
//  ForecastWeatherCell.swift
//  WeatherForecast
//
//  Created by J.E on 2023/04/03.
//

import UIKit

final class ForecastWeatherCell: UICollectionViewListCell {
    static let id = "forecast"
    let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let timeLabel = UILabel()
    let temperatureLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        temperatureLabel.textAlignment = .right
        self.backgroundConfiguration = .clear()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLayout()
        temperatureLabel.textAlignment = .right
        self.backgroundConfiguration = .clear()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearLabels()
    }
    
    private func clearLabels() {
        self.subviews.forEach {
            ($0 as? UILabel)?.text = nil
        }
    }
    
    private func configureLayout() {
        self.addSubview(timeLabel)
        self.addSubview(temperatureLabel)
        self.addSubview(icon)

        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeLabel.heightAnchor.constraint(equalTo: self.heightAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            timeLabel.trailingAnchor.constraint(equalTo: temperatureLabel.leadingAnchor)
        ])

        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            temperatureLabel.heightAnchor.constraint(equalTo: self.heightAnchor),
            temperatureLabel.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: icon.leadingAnchor, constant: -20)
        ])

        icon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            icon.heightAnchor.constraint(equalTo: self.heightAnchor),
            icon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            icon.widthAnchor.constraint(equalTo: icon.heightAnchor)
        ])
    }
    
    func updateWeather(_ data: WeatherData?) {
        self.icon.image = data?.iconImage
        self.timeLabel.text = data?.dataTime
        self.temperatureLabel.text = data?.temperature
    }
}
