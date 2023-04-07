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
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1.0).isActive = true
        return imageView
    }()
    
    private var currentLocation = UILabel()
    
    private var lowestAndHighestTemperature = UILabel()
    
    private var currentTemperature = UILabel()
    
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
        
        [currentLocation, lowestAndHighestTemperature, currentTemperature].forEach { label in
            label.textColor = .white
            label.font = .systemFont(ofSize: 18)
            self.addressInformationView.addArrangedSubview(label)
        }

        currentTemperature.font = .systemFont(ofSize: 30)
        
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
    
    //MARK: - Method
    func prepare(model: CurrentViewModel) {
        currentWeatherEmoji.image = UIImage(named: model.currentWeatherIcon)
        currentLocation.text = "서울특별시 용산구"
        lowestAndHighestTemperature.text = "최저 \(model.temperature.lowestTemperature)˚" + "최고 \(model.temperature.highestTemperature)˚ "
        currentTemperature.text = model.temperature.currentTemperature + "˚"
    }
}

