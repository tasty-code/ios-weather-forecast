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
    static var reuseIdentifier: String { String(describing: CollectionReusableHeaderView.self) }
}

final class CollectionReusableHeaderView: UICollectionReusableView, CollectionReusableHeaderViewIdentifyingProtocol {
    // MARK: - Constants
    private enum Constants {
        case maxAndMinTemperaturelabelText(tempMax: Double, tempMin: Double)
        case temperatureLabelText(temp: Double)
        
        var text: String {
            switch self {
            case .maxAndMinTemperaturelabelText(let tempMax, let tempMin):
                "최저 \(String(format: "%.1f", tempMin)) 최고 \(String(format: "%.1f", tempMax))"
            case .temperatureLabelText(let temp):
                String(format: "%.1f", temp)
            }
        }
        
        static let stackViewDefaultSpacing: CGFloat = 14
        static let labelDefaultText: String = "-"
    }
    
    // MARK: - Dependencies
    private lazy var iconDataService: DataDownloadable = IconDataService(delegate: self)
    
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
            maxAndMinTemperatureLabel.text = Constants.maxAndMinTemperaturelabelText(tempMax: tempMax, tempMin: tempMin).text
            temperatureLabel.text = Constants.temperatureLabelText(temp: temp).text
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

// MARK: Autolayout Methods
extension CollectionReusableHeaderView {
    private func setUpLayout() {
        self.addSubview(contentView)
        contentView.addSubviews([iconImageView, addressLabel, maxAndMinTemperatureLabel, temperatureLabel])
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
            addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
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
