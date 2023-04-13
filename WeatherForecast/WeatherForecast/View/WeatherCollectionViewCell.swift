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
    var tempImage = UIImageView()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        
        super.init(frame: frame)

        addSubview(timeLabel)
        addSubview(temperatureLabel)
        addSubview(tempImage)
        configureConstraint()
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Private function
    private func configureUI() {
        timeLabel.textColor = .white
        
        temperatureLabel.textColor = .white
        temperatureLabel.textAlignment = .center
    }
    
    private func configureConstraint() {
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        tempImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: self.topAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            timeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: self.frame.width * 0.7),
            timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            temperatureLabel.topAnchor.constraint(equalTo: self.topAnchor),
            temperatureLabel.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor),
            temperatureLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            temperatureLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            tempImage.topAnchor.constraint(equalTo: self.topAnchor),
            tempImage.leadingAnchor.constraint(equalTo: temperatureLabel.trailingAnchor),
            tempImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            tempImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            tempImage.widthAnchor.constraint(equalToConstant: self.frame.width * 0.1),
            tempImage.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
