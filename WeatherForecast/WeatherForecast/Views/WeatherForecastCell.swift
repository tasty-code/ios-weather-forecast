import UIKit

protocol WeatherForecastCellIdentifying {
    static var identifier: String { get }
}

extension WeatherForecastCellIdentifying {
    static var identifier: String { String(describing: WeatherForecastCell.self) }
}

protocol WeatherForecastCellConfigurable {
    func startConfigure(using model: Model.FiveDaysWeather.List?) throws
}

final class WeatherForecastCell: UICollectionViewListCell {
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let temperatureCurrentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.addArrangedSubview(temperatureCurrentLabel)
        stackView.addArrangedSubview(imageView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    private func configureUI() {
        backgroundConfiguration = .clear()
        addSubview(dateLabel)
        addSubview(stackView)
    }
    
    private func configureConstraint() {
        setDateLabelConstraint()
        setStackViewConstraint()
//        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func imageLabelConstraint() {
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: temperatureCurrentLabel.heightAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
    
    private func setDateLabelConstraint() {
        let safeArea = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: safeArea.topAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }
    
    private func setStackViewConstraint() {
        let safeArea = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
}

extension WeatherForecastCell: WeatherForecastCellConfigurable {
    func startConfigure(using model: Model.FiveDaysWeather.List?) throws {
        guard let model = model else {
            throw WeatherForecastCellError.didFailFetchCellData
        }
        
        guard let date = model.dt else {
            throw WeatherForecastCellError.noExistedDate
        }
        
        let dateString = DateFormatter.toString(by: date)
        
        guard let temperatureCurrent = model.main?.temp else {
            throw WeatherForecastCellError.noExistedTemperature
        }
        
        guard let imageType = model.weather?[0].icon else {
            throw WeatherForecastCellError.noExistedImage
        }
        
        let image = UIImage.load(from: imageType)
        
//        guard let image = UIImage(systemName: "pencil") else {
//            throw WeatherForecastHeaderViewError.noExistedImage
//        }
        
        configure(image: image, date: dateString, temperatureCurrent: temperatureCurrent)
    }

    private func configure(image: UIImage, date: String, temperatureCurrent: Double) {
        imageView.image = image
        dateLabel.text = date
        temperatureCurrentLabel.text = String(format: "%.1fº", temperatureCurrent)
    }
}

extension WeatherForecastCell: WeatherForecastCellIdentifying {
    
}

#if DEBUG
import SwiftUI

struct ViewControllerRepresentable: UIViewControllerRepresentable {
    
    // update
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    // makeui
    @available(iOS 13.0, *)
    func makeUIViewController(context: Context) -> UIViewController {
        WeatherForecastViewController()
    }
}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerRepresentable().previewDisplayName("iPhone 15")
    }
}
#endif
