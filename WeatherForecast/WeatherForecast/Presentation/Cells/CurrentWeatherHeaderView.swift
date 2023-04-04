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
        let currentWeatherEmoji = UIImageView()
        currentWeatherEmoji.image = UIImage(named: "star.pill")
        
        return currentWeatherEmoji
    }()
    
    private var currentLocation: UILabel = {
        let currentLocation = UILabel()
        currentLocation.text = "서울특별시 용산구"
        
        return currentLocation
    }()
    
    private var lowestTemperature: UILabel = {
        let lowestTemperature = UILabel()
        lowestTemperature.text = "최저 1.0˚"
        
        return lowestTemperature
    }()

    private var highestTemperature: UILabel = {
        let highestTemperature = UILabel()
        highestTemperature.text = "최고 11.0˚"
        
        return highestTemperature
    }()
    
    private var currentTemperature: UILabel = {
        let currentTemperature = UILabel()
        currentTemperature.text = "11.0˚"
        
        return currentTemperature
    }()
    
    //MARK: - StackView
    
    private var addressInformationView: UIStackView = {
        let addressInformationView = UIStackView()
        
        return addressInformationView
    }()
    
    private var currentInformationView: UIStackView = {
        let currentInformationView = UIStackView()
        
        return currentInformationView
    }()
    
    //MARK: - Configure Of Layout
    func configuration() {
        self.addSubview(currentInformationView)
        
        [currentLocation, lowestTemperature, highestTemperature, currentTemperature].forEach { label in
            self.addressInformationView.addArrangedSubview(label)
        }
        
        [currentWeatherEmoji, addressInformationView].forEach { view in
            self.currentInformationView.addArrangedSubview(view)
        }
        
        currentInformationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currentInformationView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            currentInformationView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            currentInformationView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            currentInformationView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

