//
//  CollectionViewCell.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/29/23.
//

import UIKit

protocol CollectionViewCellIdentifyingProtocol {
    static var reuseIdentifier: String { get }
}

extension CollectionViewCellIdentifyingProtocol {
    static var reuseIdentifier: String { String(describing: self) }
}

final class CollectionViewCell: UICollectionViewCell, CollectionViewCellIdentifyingProtocol {
    // MARK: - Constants
    private enum Constants {
        static let bottomBorderLineHeight: CGFloat = 1
        static let labelDefaultText: String = "-"
        static let dateTextFormatBefore: String = "yyyy-MM-dd HH:mm:ss"
        static let dateTextFormatAfter: String = "MM/dd(EE) HH시"
    }
    
    // MARK: - Dependencies
    private lazy var iconDataService: DataDownloadable = IconDataService(delegate: self)
    private lazy var dateFormattingService: DateFormattable = DateFormattingService()
    
    // MARK: - View Components
    private lazy var dateAndHourLabel: UILabel = {
        let label = UILabel(text: Constants.labelDefaultText, font: .preferredFont(forTextStyle: .headline), textColor: .white)
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel(text: Constants.labelDefaultText, font: .preferredFont(forTextStyle: .headline), textColor: .white)
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
        if let date = item.date {
            dateAndHourLabel.text = dateFormattingService.format(with: date, from: Constants.dateTextFormatBefore, to: Constants.dateTextFormatAfter)
        }
        
        if let temperature = item.main?.temp {
            temperatureLabel.text = "\(String(format: "%.1f", temperature))°"
        }
        
        if let iconCode = item.weather?.first?.icon {
            iconDataService.downloadData(serviceType: .icon(code: iconCode))
        }
        
        setUpLayout()
        setUpConstraints()
        drawUnderBorder()
    }
    
    override func prepareForReuse() {
        dateAndHourLabel.text = nil
        temperatureLabel.text = nil
        iconImageView.image = nil
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
    
    private func drawUnderBorder() {
        let border = CALayer()
        border.frame = CGRect(x: frame.origin.x, y: frame.height - Constants.bottomBorderLineHeight, width: frame.width, height: Constants.bottomBorderLineHeight)
        border.backgroundColor = CGColor(red: 255, green: 255, blue: 255, alpha: 1)
        contentView.layer.addSublayer(border)
    }
}

// MARK: ImageDataServiceDelegate Confirmation
extension CollectionViewCell: ImageDataServiceDelegate {
    func notifyImageDidUpdate(dataService: DataDownloadable, image: UIImage) {
        iconImageView.image = image
    }
}
