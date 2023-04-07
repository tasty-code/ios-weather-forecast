//
//  WeatherCollectionViewCell.swift
//  WeatherForecast
//
//  Created by 신동오 on 2023/04/05.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Static property
    static let cellIdentifier = "WeatherCollectionViewCell"

    // MARK: - Public property
    var timeLabel = UILabel()
    var temperatureLabel = UILabel()
    var tempImage = UILabel()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        
        super.init(frame: frame)

        addSubview(timeLabel)
        addSubview(temperatureLabel)
        addSubview(tempImage)
        configureLabelConstraint()
        temperatureLabel.textAlignment = .right
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Private function
    private func configureLabelConstraint() {
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        tempImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: self.topAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: self.frame.width * 7 / 10 ),
            timeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            temperatureLabel.topAnchor.constraint(equalTo: self.topAnchor),
            temperatureLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.frame.width * 7 / 10),
            temperatureLabel.trailingAnchor.constraint(equalTo: self.tempImage.leadingAnchor, constant: -10),
            temperatureLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            tempImage.topAnchor.constraint(equalTo: self.topAnchor),
            tempImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.frame.width * 9 / 10),
            tempImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            tempImage.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
