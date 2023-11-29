//
//  CollectionViewCell.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/29/23.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    // MARK: - Depencies
    static let reuseIdentifier: String = String(describing: CollectionViewCell.self)
    
    // MARK: - View Components
    private lazy var dateAndHourLabel: UILabel! = {
        let label = UILabel(font: .preferredFont(forTextStyle: .headline), textColor: .black)
        return label
    }()
    
    private lazy var temperatureLabel: UILabel! = {
        let label = UILabel(font: .preferredFont(forTextStyle: .headline), textColor: .black)
        return label
    }()
    
    private lazy var iconImageView: UIImageView! = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(_ model: ForecastModel) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
