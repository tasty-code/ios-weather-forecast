//
//  ForecastWeatherCell.swift
//  WeatherForecast
//
//  Created by 박재우 on 2023/04/04.
//

import UIKit

final class ForecastWeatherCell: UICollectionViewCell {
    static let identifier = "ForcastWeatherCell"

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "04/10(월) 13시"
        label.font = .systemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var atmosphericTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "13˚"
        label.font = .systemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()

    private lazy var weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "cloud.sun.fill")
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, atmosphericTemperatureLabel, weatherImage])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 20
        addSubview(stackView)
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func prepare(text: String) {
        dateLabel.text = text
    }
}
