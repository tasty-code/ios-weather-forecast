//
//  ForecastCell.swift
//  WeatherForecast
//
//  Created by 김경록 on 12/1/23.
//

import UIKit

final class ForecastCell: UICollectionViewCell, Reusable {
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel(textAlignment: .left)
        addSubview(label)
        
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel(textAlignment: .right)
        
        return label
    }()
    
    private let weatherIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var weatherInfoStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal,
                                    distribution: .fill,
                                    spacing: 5,
                                    subViews: [temperatureLabel, weatherIconView])
        addSubview(stackView)
        
        return stackView
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
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            weatherInfoStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            weatherInfoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            weatherInfoStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            weatherIconView.heightAnchor.constraint(equalTo: dateLabel.heightAnchor),
            weatherIconView.widthAnchor.constraint(equalTo: weatherIconView.heightAnchor, multiplier: 1)
        ])
    }
    
    func configureUI(with data: List, icon: UIImage?) {
        dateLabel.text = DateFormatter().toString(by: data.TimeOfDataForecasted)
        temperatureLabel.text = "\(data.weatherCondition.temperature)℃"
        weatherIconView.image = icon
    }
}
