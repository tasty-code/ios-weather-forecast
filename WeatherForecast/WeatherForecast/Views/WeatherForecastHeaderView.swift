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
        
        return label
    }()
    
    private let temperatureMinMaxLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        
        return label
    }()
    
    private let temperatureCurrentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        
        return label
    }()
    
    private lazy var partialInfoStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        //        stackView.heightAnchor.constraint(equalTo: totalInfoStackView.heightAnchor).isActive = true
        stackView.addArrangedSubview(locationLabel)
        stackView.addArrangedSubview(temperatureMinMaxLabel)
        
        return stackView
    }()
    
    private lazy var totalInfoStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(partialInfoStackView)
        stackView.addArrangedSubview(temperatureCurrentLabel)
        
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(totalInfoStackView)
        
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
    
    private func imageViewConstraint() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
}

extension WeatherForecastHeaderView: WeatherForecastHeaderViewIdentifying {
    
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
        
//        guard let image = UIImage(systemName: "pencil") else {
//            throw WeatherForecastHeaderViewError.noExistedImage
//        }
        
        let image = UIImage.load(from: imageType)
        
        guard let locality = placemark.locality,
              let subLocality = placemark.subLocality else {
            throw WeatherForecastHeaderViewError.noExistedLocality
        }
        
        guard let temperatureMin = model.main?.tempMin,
              let temperatureMax = model.main?.tempMax,
              let temperatureCurrent = model.main?.temp else {
            throw WeatherForecastHeaderViewError.noExistedTemperature
        }
                
        configure(image: image, locality: locality, subLocality: subLocality, temperatureMin: temperatureMin, temperatureMax: temperatureMax, temperatureCurrent: temperatureCurrent)
    }
    
    private func configure(image: UIImage, locality: String, subLocality: String, temperatureMin: Double, temperatureMax: Double, temperatureCurrent: Double) {
        imageView.image = image
        locationLabel.text = locality + " " + subLocality
        temperatureMinMaxLabel.text = "최저 " + String(format: "%.1fº", temperatureMin) +  " 최고 " + String(format: "%.1fº", temperatureMax)
        temperatureCurrentLabel.text = String(format: "%.1fº", temperatureCurrent)
    }
}
