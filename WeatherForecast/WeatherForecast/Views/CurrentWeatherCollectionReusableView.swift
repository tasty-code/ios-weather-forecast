//
//  CurrentWeatherCollectionReusableView.swift
//  WeatherForecast
//
//  Created by Rarla on 2023/11/29.
//

import UIKit

final class CurrentWeatherCollectionReusableView: UICollectionReusableView {
    static let identifier = "CurrentWeatherCellIdentifier"
    
    private let mainStackView: UIStackView = UIStackView(axis: .horizontal)
    private let detailStackView: UIStackView = UIStackView(axis: .vertical)
    
    private let iconImageView: UIImageView = UIImageView()
    
    private let addressLabel: UILabel = UILabel(text: "-")
    private let maxMinTempertureLabel: UILabel = UILabel(text: "-")
    private let tempertureLabel: UILabel = UILabel(text: "-", fontSize: 24)
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainStackView.frame = bounds
    }
    
    // MARK: - private Method
    
    private func setLayout() {
        mainStackView.addArrangedSubViews(iconImageView, detailStackView)
        detailStackView.addArrangedSubViews(addressLabel, maxMinTempertureLabel, tempertureLabel)
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    // MARK: - public Method
    
    func setMainIcon(_ icon: Data) {
        self.iconImageView.image = UIImage(data: icon)
    }
    
    func setAddressLabel(_ address: String) {
        addressLabel.text = address
    }
    
    func setMaxMinTempertureLabel(max: Double?, min: Double?) {
        guard let max = max, let min = min else { return }
        maxMinTempertureLabel.text = "최저 \(min)° 최고 \(max)°"
    }
    
    func setTempertureLabel(_ temp: Double?) {
        guard let temp = temp else { return }
        tempertureLabel.text = "\(temp)°"
    }
}
