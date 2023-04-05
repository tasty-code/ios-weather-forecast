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
        self.backgroundColor = .orange
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Private Property
    
    private var currentWeatherEmoji: UIImageView = {
        let currentWeatherEmoji = UIImageView()
        currentWeatherEmoji.image = UIImage(systemName: "cloud.sun.fill")
        currentWeatherEmoji.setContentHuggingPriority(.defaultHigh,
                                                      for: .horizontal)
        return currentWeatherEmoji
    }()
    
    private var currentLocation: UILabel = {
        let currentLocation = UILabel()
        currentLocation.text = "서울특별시 용산구"
        
        return currentLocation
    }()
    
    private var lowestAndHighestTemperature: UILabel = {
        let lowestAndHighestTemperature = UILabel()
        lowestAndHighestTemperature.text = "최저 1.0˚ 최고 11.0˚"
        
        return lowestAndHighestTemperature
    }()
    
    private var currentTemperature: UILabel = {
        let currentTemperature = UILabel()
        currentTemperature.text = "11.0˚"
        
        return currentTemperature
    }()
    
    //MARK: - StackView
    
    private var addressInformationView: UIStackView = {
        let addressInformationView = UIStackView()
        addressInformationView.axis = .vertical
        addressInformationView.spacing = 3
        return addressInformationView
    }()
    
    private var currentInformationView: UIStackView = {
        let currentInformationView = UIStackView()
        currentInformationView.spacing = 10
        return currentInformationView
    }()
    
    //MARK: - Configure Of Layout
    func configuration() {
        self.addSubview(currentInformationView)
        
        [currentLocation, lowestAndHighestTemperature, currentTemperature].forEach { label in
            self.addressInformationView.addArrangedSubview(label)
        }
        
        [currentWeatherEmoji, addressInformationView].forEach { view in
            self.currentInformationView.addArrangedSubview(view)
        }
        
        currentInformationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currentInformationView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30),
            currentInformationView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            currentInformationView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            currentInformationView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
        
        addressInformationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addressInformationView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

