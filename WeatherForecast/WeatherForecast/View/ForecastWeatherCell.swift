//
//  ForecastWeatherCell.swift
//  WeatherForecast
//
//  Created by J.E on 2023/04/03.
//

import UIKit

final class ForecastWeatherCell: UICollectionViewCell {
    static let id = "forecast"
    let icon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "rays"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let timeLabel = UILabel()
    let temperatureLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        temperatureLabel.textAlignment = .right
    }
    
    required init?(coder: NSCoder) {
        fatalError("Expected \(Self.self) initialization did fail")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timeLabel.text = nil
        temperatureLabel.text = nil
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
            icon.leadingAnchor.constraint(equalTo: temperatureLabel.trailingAnchor, constant: 20),
            icon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }
}
