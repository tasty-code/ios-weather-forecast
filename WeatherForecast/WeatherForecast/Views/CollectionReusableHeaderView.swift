//
//  CollectionReusableHeaderView.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/29/23.
//

import UIKit

final class CollectionReusableHeaderView: UICollectionReusableView {
    // MARK: Constants
    private enum Constants {
        static let stackViewDefaultSpacing: CGFloat = 4
    }
    
    // MARK: Dependencies
    static let reuseIdentifier: String = String(describing: CollectionReusableHeaderView.self)
    
    // MARK: - View Components
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: Constants.stackViewDefaultSpacing)
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel(font: .preferredFont(forTextStyle: .callout), textColor: .black)
        return label
    }()
    
    private lazy var maxAndMinTemperatureLabel: UILabel = {
        let label = UILabel(font: .preferredFont(forTextStyle: .callout), textColor: .black)
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel(font: .preferredFont(forTextStyle: .largeTitle), textColor: .black)
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpLayout()
        setUpConstraints()
    }
}

// MARK: Autolayout Methods
extension CollectionReusableHeaderView {
    private func setUpLayout() {
        self.addSubview(contentView)
        contentView.addSubviews([iconImageView, labelsStackView])
        labelsStackView.addSubviews([addressLabel, maxAndMinTemperatureLabel, temperatureLabel])
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            iconImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
        ])
        
        NSLayoutConstraint.activate([
            labelsStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor),
            labelsStackView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
        ])
    }
}
