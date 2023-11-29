//
//  CollectionViewCell.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/29/23.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    // MARK: - Dependencies
    static let reuseIdentifier: String = String(describing: CollectionViewCell.self)
    
    // MARK: - View Components
    private lazy var dateAndHourLabel: UILabel = {
        let label = UILabel(font: .preferredFont(forTextStyle: .headline), textColor: .black)
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel(font: .preferredFont(forTextStyle: .headline), textColor: .black)
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Public
    func configureCell(_ model: ForecastModel) {
        // 모델 주입 받아서 셀 드로잉
    }
    
    override func prepareForReuse() {
        // 셀 재사용 준비
    }
}

// MARK: Autolayout Methods
extension CollectionViewCell {
    private func setUpLayout() {
        self.contentView.addSubviews([dateAndHourLabel, temperatureLabel, iconImageView])
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            dateAndHourLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            dateAndHourLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
        ])
    }
}
