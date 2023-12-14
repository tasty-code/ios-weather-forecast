//
//  CurrentWeatherCollectionReusableView.swift
//  WeatherForecast
//
//  Created by Rarla on 2023/11/29.
//

import UIKit

protocol AlertDelegate: AnyObject {
    func setAlert()
}


final class CurrentWeatherCollectionReusableView: UICollectionReusableView {
    static let identifier = "CurrentWeatherCellIdentifier"
    
    weak var delegate: AlertDelegate?
    
    private let mainStackView: UIStackView = UIStackView(axis: .horizontal)
    private let detailStackView: UIStackView = UIStackView(axis: .vertical)
    private let headerStackView: UIStackView = UIStackView(axis: .horizontal)
    
    private let iconImageView: UIImageView = UIImageView()
    
    private let addressLabel: UILabel = UILabel(text: "-")
    private let maxMinTempertureLabel: UILabel = UILabel(text: "-")
    private let tempertureLabel: UILabel = UILabel(text: "-", fontSize: 24)
    
    private let paddingBox: UIView = UIView()
    
    private let locationChangeButton: UIButton = {
        let button = UIButton()
        button.setTitle("위치설정", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return button
    }()
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
        locationChangeButton.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
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

        headerStackView.addArrangedSubViews(addressLabel, locationChangeButton, paddingBox)
        mainStackView.addArrangedSubViews(iconImageView, detailStackView)
        detailStackView.addArrangedSubViews(headerStackView, maxMinTempertureLabel, tempertureLabel)
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 100),
            paddingBox.widthAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    // MARK: - public Method
    
    func setMainIcon(_ icon: Data) {
        UIView.transition(with: self.iconImageView,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { self.iconImageView.image = UIImage(data: icon) },
                          completion: nil)
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
    
    @objc func changeButtonTapped() {
        delegate?.setAlert()
    }
}
