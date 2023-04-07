//
//  WeatherCollectionViewHeader.swift
//  WeatherForecast
//
//  Created by 이상윤 on 2023/04/07.
//

import UIKit

class WeatherCollectionViewHeader: UICollectionReusableView {

    // MARK: - Static property
    static let headerIdentifier = "WeatherCollectionViewHeader"

    // MARK: - Public property
    var headerLabel = UILabel()

    // MARK: - Lifecycle
    override init(frame: CGRect) {

        super.init(frame: frame)

        addSubview(headerLabel)
        configureHeaderSubViewConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Private function
    private func configureHeaderSubViewConstraints() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: self.topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            headerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
