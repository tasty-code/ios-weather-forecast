//
//  WeatherTimeViewCell.swift
//  WeatherForecast
//
//  Created by Janine on 11/29/23.
//

import UIKit

final class WeatherTimeViewCell: UICollectionViewCell {
    static let identifier = "TimeCellIdentifier"
    
    // MARK: - private property
    private let timeLabel = UILabel(text: "")
    
    private let temperatureLabel = UILabel(text: "")
    
    private let iconImageView = UIImageView(contentMode: .scaleAspectFit)
    
    private let temperatureStack = UIStackView(axis: .horizontal)
    
    private let containerStack = UIStackView(axis: .horizontal)
    
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
        timeLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        iconImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            containerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.trailingAnchor.constraint(equalTo: containerStack.trailingAnchor),
        ])
    }
    
    // MARK: - public method
    
    func setTimeLabel(_ text: String) {
        timeLabel.text = text.dateFormatter()
    }
    
    func setTemperatureLabel(_ text: Double) {
        temperatureLabel.text = text.tempertureFormatter()
    }
    
    func setIconImage(_ data: Data, temp: Int) {
        guard let image = UIImage(data: data) else { return }
        UIView.transition(with: self.iconImageView,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.iconImageView.image = image },
                          completion: nil)
    }
}
