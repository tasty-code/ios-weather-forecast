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
        return label
    }()

    private lazy var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 40).withPriority(.defaultHigh),
            imageView.widthAnchor.constraint(equalToConstant: 40)
        ])
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    //MARK: - StackView

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, atmosphericTemperatureLabel, weatherImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
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
        dateLabel.text = DateFormatter().convertWeatherForm(from: model.forecastInformation.forecastDate)
        atmosphericTemperatureLabel.text = String().convertWeatherForm(from: model.forecastInformation.forecastDegree)
        weatherImageView.image = model.forecastEmogi
    }
}

private extension DateFormatter {
    func convertWeatherForm(from numbericDate: Double) -> String {
        let date = Date(timeIntervalSince1970: numbericDate)
        self.dateFormat = "MM/dd(E) HH시"
        self.locale = Locale(identifier:"ko_KR")
        return self.string(from: date)
    }
}

extension String {
    func convertWeatherForm(from temperature: Double) -> Self {
        let convertedTemperature = String(format: "%.1f", temperature)
        return "\(convertedTemperature)˚"
    }
}
