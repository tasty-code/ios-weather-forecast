//
//  WeatherCollectionViewCell.swift
//  WeatherForecast
//
//  Created by Wonji Ha on 12/1/23.
//

import UIKit

final class WeatherCollectionViewCell: UICollectionViewCell, WeatherCellDelegate {
    lazy var forecastStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 50
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var temperatureLabel: UILabel = {
           let label = UILabel()
           label.textAlignment = .right
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = .clear
        setUpLayouts()
        setUpConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpLayouts() {
        backgroundColor = .systemBackground
        forecastStackView.setCustomSpacing(5, after: .spacerView)
        forecastStackView.addArrangedSubviews([timeLabel, temperatureLabel])
               
        addSubview(forecastStackView)

    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            forecastStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            forecastStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            forecastStackView.heightAnchor.constraint(equalTo: self.heightAnchor),
        ])
    }
    
    func configureCell(to forecast: Forecast) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko-KR")
        formatter.dateFormat = "MM/dd(E) hh시"
        let date = Date(timeIntervalSince1970: TimeInterval(integerLiteral: Int64(forecast.timeOfData)))
        
        timeLabel.text = formatter.string(from: date)
        temperatureLabel.text = String(forecast.mainInfo.temperature) + "°"
    }
}
