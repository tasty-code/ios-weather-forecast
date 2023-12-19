//
//  WeatherHeaderView.swift
//  WeatherForecast
//
//  Created by 김경록 on 12/1/23.
//

import UIKit

final class WeatherHeaderView: UICollectionReusableView, Reusable {
    
    weak var delegate: LocationChangeable?
    
    private lazy var weatherIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        return imageView
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel(textAlignment: .left)
        
        return label
    }()
    
    private let minimumTemperatureLabel: UILabel = {
        let label = UILabel(textAlignment: .left)
        
        return label
    }()
    
    private let maximumTemperatureLabel: UILabel = {
        let label = UILabel(textAlignment: .left)
        
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal,
                                    subViews: [minimumTemperatureLabel, maximumTemperatureLabel])
        
        return stackView
    }()
    
    private let currentTemperatureLabel: UILabel = {
        let label = UILabel(font: .preferredFont(forTextStyle: .title1), textAlignment: .left)
        
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical,
                                    alignment: .fill,
                                    distribution: .fillProportionally,
                                    spacing: 5,
                                    subViews: [addressLabel, labelStackView, currentTemperatureLabel])
        addSubview(stackView)
        
        return stackView
    }()
    
    private lazy var changeLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("위치설정", for: .normal)
        button.addTarget(self, action: #selector(changeLocationButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            weatherIconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            weatherIconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            weatherIconView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            weatherIconView.widthAnchor.constraint(equalTo: weatherIconView.heightAnchor, multiplier: 1),
            
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: weatherIconView.trailingAnchor, constant: 5),
            
            changeLocationButton.topAnchor.constraint(equalTo: topAnchor),
            changeLocationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
    
    @objc
    private func changeLocationButtonTapped() {
        delegate?.displayLocationInputAlert()
    }
    
    func configureUI(with address: String?, weather: Current, icon: UIImage?) {
        let minimumTemperature = weather.main.minimumTemperature
        let maximumTemperature = weather.main.maximumTemperature
        let temperature = weather.main.temperature
        addressLabel.text = address
        minimumTemperatureLabel.text = "최저: \(minimumTemperature)℃"
        maximumTemperatureLabel.text = "최고: \(maximumTemperature)℃"
        currentTemperatureLabel.text = "\(temperature)℃"
        weatherIconView.image = icon
    }
}
