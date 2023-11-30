//
//  CollectionViewCell.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/29/23.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    // MARK: - Constants
    private enum Constants {
        static let stackViewDefaultSpacing: CGFloat = 4
        static let labelDefaultText: String = "-"
    }
    
    // MARK: - Dependencies
    static let reuseIdentifier: String = String(describing: CollectionViewCell.self)
    
    // MARK: - View Components
    private lazy var dateAndHourLabel: UILabel = {
        let label = UILabel(text: Constants.labelDefaultText, font: .preferredFont(forTextStyle: .headline), textColor: .black)
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel(text: Constants.labelDefaultText, font: .preferredFont(forTextStyle: .headline), textColor: .black)
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Public
    func configureCell(_ item: List) {
        // 모델 주입 받아서 셀 드로잉
    }
    
    override func prepareForReuse() {
        // 셀 재사용 준비
    }
}

// MARK: Autolayout Methods
extension CollectionViewCell {
    private func setUpLayout() {
        contentView.addSubviews([dateAndHourLabel, temperatureLabel, iconImageView])
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            dateAndHourLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dateAndHourLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            
            temperatureLabel.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor),
            temperatureLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            
            iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            iconImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            iconImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor),
        ])
    }
}
