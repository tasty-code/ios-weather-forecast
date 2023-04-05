//
//  WeatherHeaderView.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/30.
//

import Foundation
import UIKit

final class WeatherHeaderView: UICollectionReusableView {

    //MARK: - Constants

    private enum Constants {
        static let addressLabelString: String = "서울특별시 용산새싹마을"
        static let temperatureRangeLabelString: String = "최저 - °C, 최고 - °C"
        static let temperatureLabelString: String = "- °C"
    }

    private enum Metric {
        static let headerViewHeight: CGFloat = 100
        static let weatherIconImageViewHeightSize: CGFloat = 80
        static let weatherIconImageViewWidthAnchorInset: CGFloat = 1
        static let weatherIconImageViewLeadingAnchorInset: CGFloat = 16

        static let infoStackViewTopAnchorInset: CGFloat = 5
        static let infoStackViewLeadingAnchorInset: CGFloat = 20
        static let infoStackViewBottomAnchorInset: CGFloat = 5

        static let addressLabelFontSize: CGFloat = 13
        static let temperatureRangeLabelFontSize: CGFloat = 13
        static let temperatureLabelFontSize: CGFloat = 30

    }

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
        label.text = Constants.addressLabelString
        label.font = UIFont.systemFont(ofSize: Metric.addressLabelFontSize)
        return label
    }()

    private let temperutureRangeLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.temperatureRangeLabelString
        label.font = UIFont.systemFont(ofSize: Metric.temperatureRangeLabelFontSize)
        return label
    }()

    private let temperutureLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.temperatureLabelString
        label.font = UIFont.systemFont(ofSize: Metric.temperatureLabelFontSize)
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
        let heightLayout = self.heightAnchor.constraint(equalToConstant: Metric.headerViewHeight)
        heightLayout.priority = .defaultHigh
        heightLayout.isActive = true
        
        addSubview(weatherIconImageView)
        weatherIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherIconImageView.heightAnchor.constraint(equalToConstant: Metric.weatherIconImageViewHeightSize),
            weatherIconImageView.widthAnchor.constraint(equalTo: weatherIconImageView.heightAnchor, multiplier: Metric.weatherIconImageViewWidthAnchorInset),
            weatherIconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metric.weatherIconImageViewLeadingAnchorInset),
            weatherIconImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        addSubview(infoStackView)
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: topAnchor, constant: Metric.infoStackViewTopAnchorInset),
            infoStackView.leadingAnchor.constraint(equalTo: weatherIconImageView.trailingAnchor, constant: Metric.infoStackViewLeadingAnchorInset),
            infoStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Metric.infoStackViewBottomAnchorInset),
        ])
    }

}
