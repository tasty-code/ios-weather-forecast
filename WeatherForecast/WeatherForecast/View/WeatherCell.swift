//
//  WeatherCell.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/28.
//

import Foundation
import UIKit

final class WeatherCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let dateLabelSkeletonText = "-/-(-) -시"
        static let temperatureSkeletonText = "- °C"
        static let temperatureSuffixText = " °C"
    }

    // MARK: - Properties

    static let identifier = "WeatherCell"

    // MARK: - UI Components

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "-/-(-) -시"
        return label
    }()

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.widthAnchor.constraint(equalToConstant: 70).isActive = true
        label.text = "- °C"
        return label
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        return imageView
    }()

    private lazy var rightStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            temperatureLabel,
            iconImageView
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetData()
    }

    // MARK: - Public

    func configure(date: String, temperature: String) {
        dateLabel.text = date
        temperatureLabel.text = temperature + Constants.temperatureSuffixText
    }

    func configure(icon: UIImage) {
        iconImageView.image = icon
    }

    // MARK: - Private

    private func setupLayout() {
        addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        addSubview(rightStackView)
        rightStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            rightStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

    }
    
    private func resetData() {
        dateLabel.text = Constants.dateLabelSkeletonText
        temperatureLabel.text = Constants.temperatureSkeletonText
        iconImageView.image = nil
    }

}
