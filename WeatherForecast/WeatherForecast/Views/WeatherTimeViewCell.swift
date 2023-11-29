//
//  WeatherTimeViewCell.swift
//  WeatherForecast
//
//  Created by Janine on 11/29/23.
//

import UIKit

class WeatherTimeViewCell: UICollectionViewCell {
    static let identifier = "timeCell"
    
    // MARK: - private property
    private let timeLabel = {
        let label = UILabel()
        label.text = "TEST-001"
        
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()

    private let temperatureLabel = {
        let label = UILabel()
        label.text = "TEST-002"
        
        
        return label
    }()
    
    private let iconImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "test")
        return imageView
    }()
    
    private let temperatureStack = {
        let stack = UIStackView()
        
        stack.axis = .horizontal
        stack.distribution = .fill
        
        return stack
    }()
    
    private let containerStack = {
        let stack = UIStackView()
        
        stack.axis = .horizontal
        stack.distribution = .fill
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .darkGray
        
        return stack
    }()
    
    // MARK: - initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        temperatureStack.addArrangedSubViews(temperatureLabel, iconImageView)
        containerStack.addArrangedSubViews(timeLabel, temperatureStack)
        
        contentView.addSubview(containerStack)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - private method
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            containerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
