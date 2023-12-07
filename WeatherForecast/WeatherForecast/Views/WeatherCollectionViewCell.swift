//
//  WeatherCollectionViewCell.swift
//  WeatherForecast
//
//  Created by Wonji Ha on 12/1/23.
//

import UIKit

final class WeatherCollectionViewCell: UICollectionViewCell, WeatherCellDelegate {
    lazy var horizontalStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 50
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = .clear
        setUpLayouts()
        setUpConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpLayouts() {
        backgroundColor = .systemGreen
        addSubview(label)
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.heightAnchor.constraint(equalTo: self.heightAnchor),
        ])
    }
    
    func configureCell(to forecast: Forecast) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko-KR")
        formatter.dateFormat = "MM/dd(E) hh:mm"
        let date = Date(timeIntervalSince1970: TimeInterval(integerLiteral: Int64(forecast.timeOfData)))
        
        label.text = formatter.string(from: date) + " \(forecast.mainInfo.temperature)🌡️"
    }
}
