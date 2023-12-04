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
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "서울특별시 용산구"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let maxAndMinTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "최저 16.9 최고 20.4\n"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 16)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "20.4\n"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 24)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(locationLabel)
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
    
    func configure() {
        backgroundColor = .systemGreen
    }
    
    private func setConstraint() {
        let safeArea = self
        
        NSLayoutConstraint.activate([
            // weatherIconImageView
            weatherIconImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            weatherIconImageView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            
            // locationLabel
            locationLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            locationLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            
            // maxAndMinTemperatureLabel
            maxAndMinTemperatureLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 16),
            maxAndMinTemperatureLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor),
            
            // currentTemperatureLabel
            currentTemperatureLabel.topAnchor.constraint(equalTo: maxAndMinTemperatureLabel.bottomAnchor, constant: 16),
            currentTemperatureLabel.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor),
        ])
    }
}
