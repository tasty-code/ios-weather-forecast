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
        label.textColor = .white
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private let temperatureLabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    private let iconImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
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
        return stack
    }()
    
    private let borderLine = {
        let line = UIView()
    }
    
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
            containerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.trailingAnchor.constraint(equalTo: containerStack.trailingAnchor),
        ])
    }
    
    // MARK: - public method
    func setTimeLabel(_ text: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        guard let date = dateFormatter.date(from: text) else { return }
        dateFormatter.dateFormat = "MM/dd(E) HH시"
        
        let textString = dateFormatter.string(from: date)
        timeLabel.text = textString
    }
    
    func setTemperatureLabel(_ text: Double) {
        temperatureLabel.text = String(text) + "°"
    }
    
    func setIconImage(_ id: String) {
        if let image = ImageCacheManager.shared.getCache(id: id) {
            DispatchQueue.main.async {
                self.iconImageView.image = image
            }
        } else {
            let url = URL(string: "https://openweathermap.org/img/wn/\(id)@2x.png")
            do {
                let data = try Data(contentsOf: url!)
                guard let image = UIImage(data: data) else { return }
                
                DispatchQueue.main.async {
                    self.iconImageView.image = image
                }
                
                ImageCacheManager.shared.setCache(id: id, data: image)
                
                
            } catch let error {
                print(error)
            }

        }
    }
}
