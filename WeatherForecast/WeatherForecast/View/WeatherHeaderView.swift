//
//  WeatherHeaderView.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/30.
//

import Foundation
import UIKit

final class WeatherHeaderView: UICollectionReusableView {

    // MARK: - Properties

    static let identifier = "WeatherViewHeader"

    // MARK: - UI Components

    private let weatherIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "moon.stars.fill")!
        return view
    }()

    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "서울특별시 용산새싹마을"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()

    private let temperutureRangeLabel: UILabel = {
        let label = UILabel()
        label.text = "최저 5.0, 최고 6.8"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()

    private let temperutureLabel: UILabel = {
        let label = UILabel()
        label.text = "6.8"
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()

    private let addressAndTemperutureRange: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.contentMode = .scaleAspectFill
        stackView.distribution = .fillEqually
        stackView.axis = .vertical

        return stackView
    }()

    private let infoStackView: UIStackView =  {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.contentMode = .scaleAspectFill
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical

        return stackView
    }()

    private func setUpStackViews() {
        addressAndTemperutureRange.addArrangedSubview(addressLabel)
        addressAndTemperutureRange.addArrangedSubview(temperutureRangeLabel)

        infoStackView.addArrangedSubview(addressAndTemperutureRange)
        infoStackView.addArrangedSubview(temperutureLabel)
    }

    private func setLayoutSubviews() {
        
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        weatherIcon.heightAnchor.constraint(equalToConstant: 80).isActive = true
        weatherIcon.widthAnchor.constraint(equalTo: weatherIcon.heightAnchor, multiplier: 1).isActive = true
        weatherIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        weatherIcon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        infoStackView.leadingAnchor.constraint(equalTo: weatherIcon.trailingAnchor, constant: 20).isActive = true
        infoStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5).isActive = true
        infoStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }


    // MARK: - LifeCycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpStackViews()
        backgroundColor = .systemRed
        addSubview(weatherIcon)
        addSubview(infoStackView)
        setLayoutSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
