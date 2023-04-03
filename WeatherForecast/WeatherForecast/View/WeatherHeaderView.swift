//
//  WeatherHeaderView.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/30.
//

import Foundation
import UIKit

final class WeatherHeaderView: UICollectionReusableView {

    // MARK: - Properties

    static let identifier = "WeatherViewHeader"

    // MARK: - UI Components

    private let weatherIconImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "moon.stars.fill")!
        return view
    }()

    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "서울특별시 용산새싹마을"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()

    private let temperutureRangeLabel: UILabel = {
        let label = UILabel()
        label.text = "최저 5.0, 최고 6.8"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()

    private let temperutureLabel: UILabel = {
        let label = UILabel()
        label.text = "6.8"
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()

    private lazy var addressAndTemperutureRange: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            addressLabel,
            temperutureRangeLabel
        ])
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var infoStackView: UIStackView =  {
        let stackView = UIStackView(arrangedSubviews: [
            addressAndTemperutureRange,
            temperutureLabel
        ])
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        return stackView
    }()

    // MARK: - LifeCycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemRed
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    func configure(with currentWeatherDetail: WeatherDetail, address: String, icon: UIImage) {
        temperutureLabel.text = "\(currentWeatherDetail.temperature)"
        temperutureRangeLabel.text = "최저 \(currentWeatherDetail.minimumTemperature) 최고 \(currentWeatherDetail.maximumTemperature)"
        addressLabel.text = address
        weatherIconImageView.image = icon
    }

    // MARK: - Private

    private func setupLayout() {
        addSubview(weatherIconImageView)
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 80),
            weatherIconImageView.widthAnchor.constraint(equalTo: weatherIconImageView.heightAnchor, multiplier: 1),
            weatherIconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            weatherIconImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        addSubview(infoStackView)
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            infoStackView.leadingAnchor.constraint(equalTo: weatherIconImageView.trailingAnchor, constant: 20),
            infoStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5),
        ])
    }

}
