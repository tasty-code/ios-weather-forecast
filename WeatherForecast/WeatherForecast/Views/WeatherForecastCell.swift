import UIKit

protocol WeatherForecastCellIdentifying {
    static var identifier: String { get }
}

extension WeatherForecastCellIdentifying {
    static var identifier: String { String(describing: WeatherForecastCell.self) }
}

final class WeatherForecastCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUI() {
        contentView.backgroundColor = .gray
    }
    
    func configure(with model: String) {
        
    }
}

extension WeatherForecastCell: WeatherForecastCellIdentifying {
    
}
