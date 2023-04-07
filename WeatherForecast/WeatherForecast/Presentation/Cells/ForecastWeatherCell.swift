//
//  ForecastWeatherCell.swift
//  WeatherForecast
//
//  Created by 박재우 on 2023/04/04.
//

import UIKit

final class ForecastWeatherCell: UICollectionViewCell {
    
    //MARK: - Property
    
    static let identifier = "ForcastWeatherCell"
    
    //MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Property

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var atmosphericTemperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()

    private lazy var weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    //MARK: - StackView

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, atmosphericTemperatureLabel, weatherImage])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 20
        addSubview(stackView)
        return stackView
    }()
    
    //MARK: - Configure Of Layout
    private func configuration() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 18),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -18)
        ])
    }

    func prepare(model: ForecastViewModel) {
        dateLabel.text = DateFormatter().transWeahterDateForm(from: model.forecastInformation.forecastDate)
        atmosphericTemperatureLabel.text = model.forecastInformation.forecastDegree + "˚"
        weatherImage.image = UIImage(named: model.forecastEmogi)
    }
}

private extension DateFormatter {
    func transWeahterDateForm(from date: String) -> String {
        guard let temp = stringToDate(from: date) else { return "" }
        self.dateFormat = "MM/dd(E) HH시"
        self.locale = Locale(identifier:"ko_KR")
        return self.string(from: temp)
    }

    private func stringToDate(from date: String) -> Date? {
        self.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let data = self.date(from: date)
        return data
    }
}
