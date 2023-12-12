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
        stackView.spacing = 5
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
    
    lazy var weatherIcon: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = UIImage(systemName: "airtag.fill")
        icon.sizeThatFits(CGSize(width: 5, height: 5))
        return icon
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayouts()
        setUpConstraints()
        layer.addBorder([.bottom], color: .systemBrown, width: 1)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpLayouts() {
        forecastStackView.setCustomSpacing(0, after: .spacerView)
        forecastStackView.addArrangedSubviews([timeLabel, temperatureLabel, weatherIcon])
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
        formatter.dateFormat = "MM/dd(E) HH시"
        let date = Date(timeIntervalSince1970: TimeInterval(integerLiteral: Int64(forecast.timeOfData)))
        timeLabel.text = formatter.string(from: date)
        temperatureLabel.text = forecast.mainInfo.temperature.temperatureFormatter() + "°"
    }
}
