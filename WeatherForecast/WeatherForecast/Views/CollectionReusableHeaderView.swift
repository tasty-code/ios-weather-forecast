//
//  CollectionReusableHeaderView.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/29/23.
//

import UIKit
import CoreLocation

protocol CollectionReusableHeaderViewIdentifyingProtocol {
    static var reuseIdentifier: String { get }
}

extension CollectionReusableHeaderViewIdentifyingProtocol {
    static var reuseIdentifier: String { String(describing: self) }
}

protocol AlertPresentingDelegate: AnyObject {
    func presentAlert(collectionViewHeader: UICollectionReusableView)
}

final class CollectionReusableHeaderView: UICollectionReusableView, CollectionReusableHeaderViewIdentifyingProtocol {
    // MARK: - Constants
    private enum Constants {
        static let stackViewDefaultSpacing: CGFloat = 14
        static let labelDefaultText: String = "-"
        static let prefix: String = "최고"
        static let suffix: String = "최저"
        static let celsiusIcon: String = "°"
        static let locationChangeButtonLabel: String = "위치변경"
    }
    
    // MARK: - Dependencies
    private lazy var iconDataService: DataDownloadable = IconDataService(delegate: self)
    weak var delegate: AlertPresentingDelegate?
    
    // MARK: - View Components
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel(text: Constants.labelDefaultText, font: .preferredFont(forTextStyle: .callout), textColor: .white, textAlignment: .left)
        return label
    }()
    
    private lazy var locationChangeButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.buttonSize = .mini
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0.1, leading: 0.1, bottom: 0.1, trailing: 0.1)
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.locationChangeButtonLabel, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        button.addTarget(self, action: #selector(presentAlert), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var maxAndMinTemperatureLabel: UILabel = {
        let label = UILabel(text: Constants.labelDefaultText, font: .preferredFont(forTextStyle: .callout), textColor: .white, textAlignment: .left)
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel(text: Constants.labelDefaultText, font: .preferredFont(forTextStyle: .largeTitle), textColor: .white, textAlignment: .left)
        return label
    }()
    
    // MARK: - Public
    func configureHeaderCell(item: WeatherModel, placemark: CLPlacemark) {
        if let temp = item.main?.temp, let tempMax = item.main?.tempMax, let tempMin = item.main?.tempMin {
            maxAndMinTemperatureLabel.text = "\(Constants.prefix) \(String(format: "%.1f", tempMax))\(Constants.celsiusIcon) \(Constants.suffix) \(String(format: "%.1f", tempMin))\(Constants.celsiusIcon)"
            temperatureLabel.text = "\(String(format: "%.1f", temp))"
        }
        
        if let iconCode = item.weather?.first?.icon {
            iconDataService.downloadData(serviceType: .icon(code: iconCode))
        }
        
        var address: String = String()
        if let administrativeArea = placemark.administrativeArea {
            address += administrativeArea
        }
        
        if let thoroughfare = placemark.thoroughfare {
            address += thoroughfare
        }
        
        addressLabel.text = address
        
        setUpLayout()
        setUpConstraints()
    }
}

// MARK: Private Methods
extension CollectionReusableHeaderView {
    @objc private func presentAlert() {
        delegate?.presentAlert(collectionViewHeader: self)
    }
}

// MARK: Autolayout Methods
extension CollectionReusableHeaderView {
    private func setUpLayout() {
        self.addSubview(contentView)
        contentView.addSubviews([iconImageView, addressLabel, locationChangeButton, maxAndMinTemperatureLabel, temperatureLabel])
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            iconImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor),
        ])
        
        NSLayoutConstraint.activate([
            addressLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor),
            addressLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            locationChangeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            locationChangeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            maxAndMinTemperatureLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor),
            maxAndMinTemperatureLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor),
            maxAndMinTemperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            temperatureLabel.topAnchor.constraint(equalTo: maxAndMinTemperatureLabel.bottomAnchor),
            temperatureLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            temperatureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}

// MARK: ImageDataServiceDelegate Confirmation
extension CollectionReusableHeaderView: ImageDataServiceDelegate {
    func notifyImageDidUpdate(dataService: DataDownloadable, image: UIImage) {
        iconImageView.image = image
    }
}
