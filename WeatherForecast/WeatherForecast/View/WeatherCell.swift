//
//  WeatherCell.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/28.
//

import UIKit

final class WeatherCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    private enum Constants {
        static let dateLabelSkeletonText: String = "-/-(-) -시"
        static let temperatureSkeletonText: String = "- °C"
        static let temperatureSuffixText: String = " °C"
    }
    
    private enum Metric {
        static let temperatureLabelWidth: CGFloat = 70
        static let iconImageViewWidth: CGFloat = 50
        
        static let dateLabelLeadingInset: CGFloat = 16
        
        static let rightStackViewTrailingInset: CGFloat = 16
        static let rightStackViewSpacing: CGFloat = 8
    }

    // MARK: - Properties

    static let identifier = "WeatherCell"

    // MARK: - UI Components

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.dateLabelSkeletonText
        return label
    }()

    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.widthAnchor.constraint(equalToConstant: Metric.temperatureLabelWidth).isActive = true
        label.text = Constants.temperatureSkeletonText
        return label
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: Metric.iconImageViewWidth).isActive = true
        return imageView
    }()

    private lazy var rightStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            temperatureLabel,
            iconImageView
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = Metric.rightStackViewSpacing
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
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: Metric.dateLabelLeadingInset),
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        addSubview(rightStackView)
        rightStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trailingAnchor.constraint(equalTo: rightStackView.trailingAnchor,
                                      constant: Metric.rightStackViewTrailingInset),
            rightStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

    }
    
    private func resetData() {
        dateLabel.text = Constants.dateLabelSkeletonText
        temperatureLabel.text = Constants.temperatureSkeletonText
        iconImageView.image = nil
    }

}
