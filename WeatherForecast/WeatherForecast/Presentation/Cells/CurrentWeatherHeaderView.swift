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
    
    private var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var currentLocationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    private var lowestAndHighestTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    private var currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30)
        label.textColor = .white
        return label
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
        currentInformationView.axis = .horizontal
        currentInformationView.spacing = 30
        return currentInformationView
    }()

    //MARK: - Configure Of Layout

    func configuration() {
        self.addSubview(currentInformationView)

        [currentLocationLabel, lowestAndHighestTemperatureLabel, currentTemperatureLabel].forEach { label in
            self.addressInformationView.addArrangedSubview(label)
        }


        [weatherImageView, addressInformationView].forEach { view in
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
        let lowestTemperature = String().convertWeatherForm(from: model.temperature.lowestTemperature)
        let highestTemperature = String().convertWeatherForm(from: model.temperature.highestTemperature)
        let currentTemperature = String().convertWeatherForm(from: model.temperature.currentTemperature)

        weatherImageView.image = UIImage(data: model.currentInformation.currentWeatherIcon)
        currentLocationLabel.text = model.currentInformation.currentLocationAddress
        lowestAndHighestTemperatureLabel.text = "최저 \(lowestTemperature) 최고 \(highestTemperature)"
        currentTemperatureLabel.text = currentTemperature
    }
}

extension NSLayoutConstraint {
    func withPriority(_ priority: UILayoutPriority) -> Self {
        self.priority = priority
        return self
    }
}
