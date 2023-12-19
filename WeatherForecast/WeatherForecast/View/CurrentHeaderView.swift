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
        
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.addArrangedSubview(cellImage)
        stackView.addArrangedSubview(temperatureLabelStackView)
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.spacing = 8
        
        return stackView
    }()
    
    private lazy var locationLabelStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.addArrangedSubview(locationLabel)
        stackView.addArrangedSubview(minMaxLabel)
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private lazy var temperatureLabelStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.addArrangedSubview(locationLabelStackView)
        stackView.addArrangedSubview(temperatureLabel)
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private func headerViewConfigure() {
        addSubview(headerStackView)

        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: topAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellImage.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 1.0)
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
