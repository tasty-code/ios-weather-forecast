//
//  WeatherHeaderView.swift
//  WeatherForecast
//
//  Created by J.E on 2023/04/03.
//

import UIKit

final class WeatherHeaderView: UICollectionViewCell {
    static let id = "current"
    let headerView = CurrentWeatherView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureLayout() {
        self.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            headerView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearLabels()
    }
    
    private func clearLabels() {
        headerView.stackView.subviews.forEach {
            ($0 as? UILabel)?.text = nil
        }
    }
    
    func updateWeather(_ data: WeatherData?, in address: String?) {
        self.headerView.image.image = data?.iconImage
        self.headerView.temperatureLabel.text = data?.temperature ?? "-"
        self.headerView.minMaxTemperatureLabel.text = data?.temperatureString() ?? "-"
        self.headerView.addressLabel.text = address ?? "-"
    }
}
