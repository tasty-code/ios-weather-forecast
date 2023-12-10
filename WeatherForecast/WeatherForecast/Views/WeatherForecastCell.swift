import UIKit

protocol WeatherForecastCellIdentifying {
    static var identifier: String { get }
}

extension WeatherForecastCellIdentifying {
    static var identifier: String { String(describing: WeatherForecastCell.self) }
}

final class WeatherForecastCell: UICollectionViewListCell {
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        
        return label
    }()
    
    private let temperatureCurrentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white

        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.addArrangedSubview(temperatureCurrentLabel)
        stackView.addArrangedSubview(imageView)
        
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
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
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
    
    // configure 하나로 처리
    func configure(date: String) {
        dateLabel.text = date
    }
    
    func configure(temperatureCurrent: Double) {
        temperatureCurrentLabel.text = String(format: "%.1fº", temperatureCurrent)
    }
    
    func configure(image: UIImage) {
//        imageView.load()
        imageView.image = image
    }
}

//extension UIImageView {
//    func load() {
//        networker?.networkManager.request
//    }
//}

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
