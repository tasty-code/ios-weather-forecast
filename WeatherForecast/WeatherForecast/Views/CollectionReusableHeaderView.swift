//
//  CollectionReusableHeaderView.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/29/23.
//

import UIKit
import CoreLocation

final class CollectionReusableHeaderView: UICollectionReusableView {
    // MARK: - Constants
    private enum Constants {
        case maxAndMinTemperaturelabelText(tempMax: Double, tempMin: Double)
        case temperatureLabelText(temp: Double)
        
        var text: String {
            switch self {
            case .maxAndMinTemperaturelabelText(let tempMax, let tempMin):
                "최저 \(String(format: "%.f1", tempMin)) 최고 \(String(format: "%.f1", tempMax))"
            case .temperatureLabelText(let temp):
                String(format: "%.f1", temp)
            }
        }
        
        static let stackViewDefaultSpacing: CGFloat = 8
        static let labelDefaultText: String = "-"
    }
    
    // MARK: - Static
    static let reuseIdentifier: String = String(describing: CollectionReusableHeaderView.self)
    
    // MARK: - Dependencies
    private lazy var iconDataService: DataDownloadable = IconDataService(delegate: self)
    
    // MARK: - View Components
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, alignment: .leading, distribution: .fill, spacing: Constants.stackViewDefaultSpacing)
        return stackView
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel(text: Constants.labelDefaultText, font: .preferredFont(forTextStyle: .callout), textColor: .white)
        return label
    }()
    
    private lazy var maxAndMinTemperatureLabel: UILabel = {
        let label = UILabel(text: Constants.labelDefaultText, font: .preferredFont(forTextStyle: .callout), textColor: .white)
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel(text: Constants.labelDefaultText, font: .preferredFont(forTextStyle: .largeTitle), textColor: .white)
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
    
    // MARK: - Public
    func configureHeaderCell(item: WeatherModel, placemark: CLPlacemark) {
        if let temp = item.main?.temp, let tempMax = item.main?.tempMax, let tempMin = item.main?.tempMin {
            maxAndMinTemperatureLabel.text = Constants.maxAndMinTemperaturelabelText(tempMax: tempMax, tempMin: tempMin).text
            temperatureLabel.text = Constants.temperatureLabelText(temp: temp).text
        }
        
        var address: String = String()
        if let administrativeArea = placemark.administrativeArea {
            address += administrativeArea
        }
        
        if let thoroughfare = placemark.thoroughfare {
            address += thoroughfare
        }
        
        addressLabel.text = address
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
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
        ])
        
        NSLayoutConstraint.activate([
            labelsStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor),
            labelsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            labelsStackView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
        ])
    }
}

// MARK: ImageDataServiceDelegate Confirmation
extension CollectionReusableHeaderView: ImageDataServiceDelegate {
    func notifyImageDidUpdate(dataService: DataDownloadable, image: UIImage) {
        iconImageView.image = image
    }
}
