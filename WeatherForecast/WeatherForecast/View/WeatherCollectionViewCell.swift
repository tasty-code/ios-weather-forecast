//
//  WeatherCollectionCellView.swift
//  WeatherForecast
//
//  Created by 김예준 on 12/1/23.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    static let identifier = "WeatherCollectionViewCell"
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 24)
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 24)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var weatherIconImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(dateLabel)
        addSubview(temperatureLabel)
        addSubview(weatherIconImageView2)
        
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            // dateLabel
            dateLabel.topAnchor.constraint(equalTo: self.topAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            // temperatureLabel
            temperatureLabel.topAnchor.constraint(equalTo: self.topAnchor),
            temperatureLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: weatherIconImageView2.leadingAnchor),
            
            // weatherIconImageView
            weatherIconImageView2.topAnchor.constraint(equalTo: self.topAnchor),
            weatherIconImageView2.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            weatherIconImageView2.widthAnchor.constraint(equalToConstant: 60),
            weatherIconImageView2.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
