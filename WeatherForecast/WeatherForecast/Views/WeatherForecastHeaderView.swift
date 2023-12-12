import UIKit
import CoreLocation

protocol WeatherForecastHeaderViewIdentifying {
    static var identifier: String { get }
}

extension WeatherForecastHeaderViewIdentifying {
    static var identifier: String { String(describing: WeatherForecastHeaderView.self) }
}

protocol WeatherForecastHeaderViewConfigurable {
    func startConfigure(_ placemark: CLPlacemark?, using model: Model.CurrentWeather?) throws
}

final class WeatherForecastHeaderView: UICollectionReusableView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let temperatureMinMaxLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let temperatureCurrentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var partialInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(locationLabel)
        stackView.addArrangedSubview(temperatureMinMaxLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var totalInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(partialInfoStackView)
        stackView.addArrangedSubview(temperatureCurrentLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(totalInfoStackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureUI() {
        backgroundColor = .clear
        addSubview(stackView)
    }
    
    private func configureConstraints() {
        stackViewConstraint()
        totalInfoStackViewConstraint()
        imageViewConstraint()
    }
    
    private func stackViewConstraint() {
        let safeArea = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }
    
    private func totalInfoStackViewConstraint() {
        totalInfoStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
    }
    
    private func imageViewConstraint() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: stackView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }
}

extension WeatherForecastHeaderView: WeatherForecastHeaderViewConfigurable {
    func startConfigure(_ placemark: CLPlacemark?, using model: Model.CurrentWeather?) throws {
        
        guard let model = model,
              let placemark = placemark else {
            throw WeatherForecastHeaderViewError.didFailFetchHeaderData
        }
        
        guard let imageType = model.weather?[0].icon else {
            throw WeatherForecastCellError.noExistedImage
        }
        
        guard let locality = placemark.locality,
              let subLocality = placemark.subLocality else {
            throw WeatherForecastHeaderViewError.noExistedLocality
        }
        
        guard let temperatureMin = model.main?.tempMin,
              let temperatureMax = model.main?.tempMax,
              let temperatureCurrent = model.main?.temp else {
            throw WeatherForecastHeaderViewError.noExistedTemperature
        }

        UIImage.load(from: imageType) { image in
            self.configure(image: image, locality: locality, subLocality: subLocality, temperatureMin: temperatureMin, temperatureMax: temperatureMax, temperatureCurrent: temperatureCurrent)
        }
    }
    
    private func configure(image: UIImage, locality: String, subLocality: String, temperatureMin: Double, temperatureMax: Double, temperatureCurrent: Double) {
        imageView.image = image
        locationLabel.text = locality + " " + subLocality
        temperatureMinMaxLabel.text = "최저 " + String(format: "%.1fº", temperatureMin) +  " 최고 " + String(format: "%.1fº", temperatureMax)
        temperatureCurrentLabel.text = String(format: "%.1fº", temperatureCurrent)
    }
}

extension WeatherForecastHeaderView: WeatherForecastHeaderViewIdentifying {
    
}
