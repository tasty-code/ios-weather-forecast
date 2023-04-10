//
//  WeatherCollectionViewHeader.swift
//  WeatherForecast
//
//  Created by 이상윤 on 2023/04/07.
//

import UIKit

class WeatherCollectionViewHeader: UICollectionReusableView {

    // MARK: - Static property
    static let headerIdentifier = "WeatherCollectionViewHeader"

    // MARK: - Public property
    var weatherImage = UIImageView()
    var locationLabel = UILabel()
    var tempMinAndMaxLabel = UILabel()
    var tempLabel = UILabel()

    // MARK: - Lifecycle
    override init(frame: CGRect) {

        super.init(frame: frame)

        addSubview(weatherImage)
        addSubview(locationLabel)
        addSubview(tempMinAndMaxLabel)
        addSubview(tempLabel)
        configureHeaderSubViewConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Private function
    private func configureHeaderSubViewConstraints() {
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        tempMinAndMaxLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            weatherImage.topAnchor.constraint(equalTo: self.topAnchor),
            weatherImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            weatherImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            weatherImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            weatherImage.widthAnchor.constraint(equalToConstant: self.frame.width * 0.25),

            locationLabel.topAnchor.constraint(equalTo: self.topAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: weatherImage.trailingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            tempMinAndMaxLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor),
            tempMinAndMaxLabel.leadingAnchor.constraint(equalTo: weatherImage.trailingAnchor),
            tempMinAndMaxLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            tempLabel.topAnchor.constraint(equalTo: tempMinAndMaxLabel.bottomAnchor),
            tempLabel.leadingAnchor.constraint(equalTo: weatherImage.trailingAnchor),
            tempLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tempLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
