import UIKit

final class HeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "Header"
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var headerImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var locationLabel: UILabel = UILabel.createCustomUILabel(of: 16)
    
    private lazy var minMaxTemperatureLabel: UILabel = UILabel.createCustomUILabel(of: 16)
    
    private lazy var currentTemperatureLabel: UILabel = UILabel.createCustomUILabel(of: 24)
    
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
    
    func updateContent(_ currentWeather: CurrentWeather, icon: UIImage) {
        minMaxTemperatureLabel.text = "최고: \(currentWeather.temperature.tempMax)°  최저: \(currentWeather.temperature.tempMin)°"
        currentTemperatureLabel.text = "\(currentWeather.temperature.temp)°"
        headerImageView.image = icon
    }
    
    func updateAddress(covertedName: String) {
        locationLabel.text = covertedName
    }
}

extension UILabel {
    
    static func createCustomUILabel(of size: CGFloat) -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: size)
        return label
    }
}
