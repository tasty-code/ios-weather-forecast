//
//  WeatherHeaderView.swift
//  WeatherForecast
//
//  Created by 김경록 on 12/1/23.
//

import UIKit

class WeatherHeaderView: UICollectionReusableView, Reusable {
    
    private lazy var weatherIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        return imageView
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel(textAlignment: .center)
        label.text = " - "
        
        return label
    }()
    
    private lazy var minimumTemperatureLabel: UILabel = {
        let label = UILabel(textAlignment: .center)
        label.text = " - "
        
        return label
    }()
    
    private lazy var maximumTemperatureLabel: UILabel = {
        let label = UILabel(textAlignment: .center)
        
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal,
                                    spacing: 3,
                                    subViews: [minimumTemperatureLabel, maximumTemperatureLabel])
        
        return stackView
    }()
    
    private lazy var currentTemperatureLabel: UILabel = {
        let label = UILabel(font: .preferredFont(forTextStyle: .title3), textAlignment: .center)
        
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical,
                                    spacing: 5,
                                    subViews: [addressLabel, labelStackView, currentTemperatureLabel])
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
            weatherIconView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            weatherIconView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            weatherIconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            weatherIconView.widthAnchor.constraint(equalTo: weatherIconView.heightAnchor, multiplier: 1),
            
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            contentStackView.leadingAnchor.constraint(equalTo: weatherIconView.trailingAnchor, constant: 10)
        ])
    }
}
