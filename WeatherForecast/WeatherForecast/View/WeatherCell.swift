//
//  WeatherCell.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/28.
//

import Foundation
import UIKit

final class WeatherCell: UICollectionViewCell {

    // MARK: - Properties

    static let identifier = "WeatherCell"

    // MARK: - UI Components

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "12/44(천) 32시"
        label.backgroundColor = .brown
        return label
    }()

    private let temperutuerLabel: UILabel = {
        let label = UILabel()
        label.text = "12.5"
        return label
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "cloud.sun.fill")
        return imageView
    }()

    private lazy var rightStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            temperutuerLabel,
            iconImageView
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()

    private let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
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

    func configure(with text: String) {
        dateLabel.text = text
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

        addSubview(bottomLineView)
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomLineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bottomLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomLineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomLineView.heightAnchor.constraint(equalToConstant: 1)
        ])

    }

}
