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
        static let dateTextFormatBefore: String = "yyyy-MM-dd HH:mm:ss"
        static let dateTextFormatAfter: String = "MM/dd(EE) HH시"
    }
    
    // MARK: - Static
    static let reuseIdentifier: String = String(describing: CollectionViewCell.self)
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Public
    func configureCell(_ item: List) {
        if let dateText = item.dateTxt {
            dateAndHourLabel.text = dateFormattingService.format(with: dateText, from: Constants.dateTextFormatBefore, to: Constants.dateTextFormatAfter)
        }
        
        if let temperature = item.main?.temp {
            temperatureLabel.text = String(format: "%.1f", temperature)
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
        border.frame = CGRect(x: 0, y: frame.height - Constants.stackViewDefaultSpacing, width: frame.width, height: Constants.stackViewDefaultSpacing)
        contentView.layer.addSublayer(border)
    }
}

// MARK: ImageDataServiceDelegate Confirmation
extension CollectionViewCell: ImageDataServiceDelegate {
    func notifyImageDidUpdate(dataService: DataDownloadable, image: UIImage) {
        iconImageView.image = image
    }
}
