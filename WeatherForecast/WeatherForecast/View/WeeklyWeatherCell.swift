//
//  WeeklyWeatherCell.swift
//  WeatherForecast
//
//  Created by 김수경 on 2023/12/08.
//

import UIKit

final class WeeklyWeatherCell: UICollectionViewCell, ReuseIdentifiable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private lazy var cellStack: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.addArrangedSubview(temperatureLabel)
        stackView.addArrangedSubview(weatherImageView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private func configure() {
        addSubview(dateLabel)
        addSubview(cellStack)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
             
            weatherImageView.heightAnchor.constraint(equalTo: dateLabel.heightAnchor),
            weatherImageView.widthAnchor.constraint(equalTo: weatherImageView.heightAnchor),
            
            cellStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func updateUI(date: String, temperature: String, image: UIImage?) {
        dateLabel.text = date
        temperatureLabel.text = temperature
        weatherImageView.image = image
    }
}
