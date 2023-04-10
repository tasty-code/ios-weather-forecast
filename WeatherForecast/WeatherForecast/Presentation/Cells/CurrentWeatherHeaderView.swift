//
//  CurrentWeatherHeaderView.swift
//  WeatherForecast
//
//  Created by Jason on 2023/04/04.
//

import UIKit

class CurrentWeatherHeaderView: UICollectionReusableView {
    
    //MARK: - Property
    
    static let identifier = "weatherHeaderView"
    
    //MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Private Property
    
    private var currentWeatherEmoji: UIImageView = {
        let imageView = UIImageView()
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var currentLocationLabel = UILabel()
    
    private var lowestAndHighestTemperatureLabel = UILabel()
    
    private var currentTemperatureLabel = UILabel()
    
    //MARK: - StackView
    
    private var addressInformationView: UIStackView = {
        let addressInformationView = UIStackView()
        addressInformationView.axis = .vertical
        addressInformationView.spacing = 3
        return addressInformationView
    }()
    
    private var currentInformationView: UIStackView = {
        let currentInformationView = UIStackView()
        currentInformationView.axis = .horizontal
        currentInformationView.spacing = 30
        return currentInformationView
    }()
    
    //MARK: - Configure Of Layout
    func configuration() {
        self.addSubview(currentInformationView)
        
        [currentLocationLabel, lowestAndHighestTemperatureLabel, currentTemperatureLabel].forEach { label in
            label.textColor = .white
            label.font = .systemFont(ofSize: 18)
            self.addressInformationView.addArrangedSubview(label)
        }

        currentTemperatureLabel.font = .systemFont(ofSize: 30)
        
        [currentWeatherEmoji, addressInformationView].forEach { view in
            self.currentInformationView.addArrangedSubview(view)
        }
        
        currentInformationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currentInformationView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 15).withPriority(.defaultHigh),
            currentInformationView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            currentInformationView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            currentInformationView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -15).withPriority(.defaultHigh)
        ])
    }
    
    //MARK: - Method
    func prepare(model: CurrentViewModel) {
        let lowestTemperature = String(format: "%.1f", Float(model.temperature.lowestTemperature) ?? 0)
        let highestTemperature = String(format: "%.1f", Float(model.temperature.highestTemperature) ?? 0)
        let currentTemperature = String(format: "%.1f", Float(model.temperature.currentTemperature) ?? 0)

        currentWeatherEmoji.image = UIImage(data: model.currentInformation.currentWeatherIcon)
        currentLocationLabel.text = model.currentInformation.currentLocationAddress
        lowestAndHighestTemperatureLabel.text = "최저 \(lowestTemperature)˚ 최고 \(highestTemperature)˚"
        currentTemperatureLabel.text = currentTemperature + "˚"
    }
}

extension NSLayoutConstraint {
    func withPriority(_ priority: UILayoutPriority) -> Self {
        self.priority = priority
        return self
    }
}
