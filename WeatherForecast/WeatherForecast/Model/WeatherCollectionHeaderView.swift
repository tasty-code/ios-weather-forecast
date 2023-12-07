//
//  WeatherCollectionHeaderView.swift
//  WeatherForecast
//
//  Created by 김예준 on 12/1/23.
//

import UIKit

class WeatherCollectionHeaderView: UICollectionReusableView {
    static let identifier = "CustomCollectionHeaderView"
    
    lazy var weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let maxAndMinTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 24)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(weatherIconImageView)
        addSubview(addressLabel)
        addSubview(maxAndMinTemperatureLabel)
        addSubview(currentTemperatureLabel)
        
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setConstraint() {
        
        NSLayoutConstraint.activate([
            // weatherIconImageView
            weatherIconImageView.topAnchor.constraint(equalTo: self.topAnchor),
            weatherIconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 120),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 120),
            
            // weatherIconImageView
            weatherIconImageView.topAnchor.constraint(equalTo: self.topAnchor),
            weatherIconImageView.leadingAnchor.constraint(equalTo: weatherIconImageView.trailingAnchor),
            
            // addressLabel
            addressLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            addressLabel.leadingAnchor.constraint(equalTo: weatherIconImageView.trailingAnchor),
            
            // maxAndMinTemperatureLabel
            maxAndMinTemperatureLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 16),
            maxAndMinTemperatureLabel.leadingAnchor.constraint(equalTo: weatherIconImageView.trailingAnchor),
            
            // currentTemperatureLabel
            currentTemperatureLabel.topAnchor.constraint(equalTo: maxAndMinTemperatureLabel.bottomAnchor, constant: 16),
            currentTemperatureLabel.leadingAnchor.constraint(equalTo: weatherIconImageView.trailingAnchor),
        ])
    }
    
    func bind(address: String, weatherData: WeatherToday) {
        addressLabel.text = address
        
        // TODO: view에서 format 하는게 맞는가? translate 하는게 맞는가?
        
        let strTemperature = Formatter.temperatureFormat(weatherData.main.temp)
        let strTemperatureMin = Formatter.temperatureFormat(weatherData.main.tempMin)
        let strTemperatureMax = Formatter.temperatureFormat(weatherData.main.tempMax)
        
        currentTemperatureLabel.text = strTemperature
        maxAndMinTemperatureLabel.text = "최저 \(strTemperatureMin) 최고 \(strTemperatureMax)"
        
        let icon = weatherData.weather[0].icon
        let weatherIconURI = "https://openweathermap.org/img/wn/\(icon)@2x.png"
        let url = URL(string: weatherIconURI)
        weatherIconImageView.load(url: url!) // TODO: 강제 언래핑
        
    }
    
}
