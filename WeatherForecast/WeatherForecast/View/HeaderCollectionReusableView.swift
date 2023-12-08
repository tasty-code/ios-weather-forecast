import UIKit

final class HeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "Header"
    
    let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    let headerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "sunny"))
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return imageView
    }()
    
    let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    let minMaxTemperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    let currentTemperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "10°"
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHeaderStackView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupHeaderStackView() {
        addSubview(headerStackView)
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: topAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            headerStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            headerImageView.widthAnchor.constraint(equalTo: headerImageView.heightAnchor, multiplier: 1.0)
        ])
        
        headerStackView.addArrangedSubview(headerImageView)
        headerStackView.addArrangedSubview(infoStackView)
        
        infoStackView.addArrangedSubview(locationLabel)
        infoStackView.addArrangedSubview(minMaxTemperatureLabel)
        infoStackView.addArrangedSubview(currentTemperatureLabel)
    }
    
    func updateContent(_ currentWeather: CurrentWeather) {
        locationLabel.text = currentWeather.name
        minMaxTemperatureLabel.text = "최고: \(currentWeather.temperature.tempMax)  최저: \(currentWeather.temperature.tempMin)"
        currentTemperatureLabel.text = "\(currentWeather.temperature.temp)°"
    }
}
