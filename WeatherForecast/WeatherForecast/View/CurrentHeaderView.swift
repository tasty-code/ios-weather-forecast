//
//  HeaderView.swift
//  WeatherForecast
//
//  Created by 김수경 on 2023/12/08.
//

import UIKit

final class CurrentHeaderView: UICollectionReusableView, ReuseIdentifiable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        headerViewConfigure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private lazy var cellImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var minMaxLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func headerViewConfigure() {
        addSubview(cellImage)
        addSubview(locationLabel)
        addSubview(minMaxLabel)
        addSubview(temperatureLabel)
        
        let safeArea = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            cellImage.topAnchor.constraint(equalTo: safeArea.topAnchor),
            cellImage.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            cellImage.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            cellImage.widthAnchor.constraint(equalTo: cellImage.heightAnchor, multiplier: 1.0),
            
            locationLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
            minMaxLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor),
            minMaxLabel.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            minMaxLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
            temperatureLabel.topAnchor.constraint(equalTo: minMaxLabel.bottomAnchor),
            temperatureLabel.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            temperatureLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    func updateUI(address: String, weather: CurrentWeather, image: UIImage?) {
        guard let minTemperature = weather.main?.minTemperature,
              let maxTemperature = weather.main?.maxTemperature
        else {
            return
        }
        
        locationLabel.text = address
        minMaxLabel.text = "최저 \(String(format: "%.1f", minTemperature))  최고 \(String(format: "%.1f", maxTemperature))"
        
        guard let temperature = weather.main?.temperature else { return }
        temperatureLabel.text = String(format: "%.1f", temperature)
        
        cellImage.image = image
    }
}
