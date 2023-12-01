//
//  ForecastCell.swift
//  WeatherForecast
//
//  Created by 김경록 on 12/1/23.
//

import UIKit

class ForecastCell: UICollectionViewCell, Reusable {
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var weatherIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var weatherInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [temperatureLabel,weatherIconView])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        return stackView
    }()
    
    private lazy var borderView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        return view
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
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -0.3),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            weatherInfoStackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -0.3),
            weatherInfoStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            borderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: trailingAnchor),
            borderView.bottomAnchor.constraint(equalTo: bottomAnchor),
            borderView.heightAnchor.constraint(equalToConstant: 0.3)
        ])
    }
}
