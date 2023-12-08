import UIKit
import CoreLocation

final class WeatherForecastView: UIView {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { section, environment in
            //            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
            //            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
            //            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
            configuration.headerMode = .supplementary
            configuration.backgroundColor = .clear
            
            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: environment)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.15))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            section.boundarySupplementaryItems = [header]
            
            return section
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(WeatherForecastCell.self, forCellWithReuseIdentifier: WeatherForecastCell.identifier)
        collectionView.register(
            WeatherForecastHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: WeatherForecastHeaderView.identifier
        )
        
        return collectionView
    }()
    
    private var currentWeathermodel: Model.CurrentWeather?
    private var fiveDaysWeatherModel: Model.FiveDaysWeather?
    private var locality: String?
    private var subLocality: String?
    private var placemark: CLPlacemark?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureUI() {
        self.backgroundColor = .clear
        self.addSubview(collectionView)
        collectionView.backgroundView = UIImageView(image: UIImage(named: "backgroundImage"))
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func configureConstraint() {
        let safeArea = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    func sendCurrentWeatherModel(model: Model.CurrentWeather, placemark: CLPlacemark) {
        currentWeathermodel = model
        self.placemark = placemark
    }
    
    func sendFiveDaysWeatherModel(model: Model.FiveDaysWeather) {
        fiveDaysWeatherModel = model
    }
    
    func sendLocation(_ locality: String?, _ subLocality: String?) {
        self.locality = locality
        self.subLocality = subLocality
    }
}

extension WeatherForecastView: UICollectionViewDelegate {
    
}

extension WeatherForecastView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: WeatherForecastCell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherForecastCell.identifier, for: indexPath) as! WeatherForecastCell
        
        if let date = fiveDaysWeatherModel?.list?[indexPath.row].dt {
            let date = NSDate(timeIntervalSince1970: TimeInterval(date))
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier:"ko_KR")
            dateFormatter.dateFormat = "MM/dd(E) HH시"
            let time = dateFormatter.string(from: date as Date)
            cell.configure(date: time)
        }
        
        if let temperatureCurrent = fiveDaysWeatherModel?.list?[indexPath.row].main?.temp {
            cell.configure(temperatureCurrent: temperatureCurrent)
        }
        
        if let image = UIImage(systemName: "square.and.arrow.up") {
            cell.configure(image: image)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: WeatherForecastHeaderView.identifier, for: indexPath) as? WeatherForecastHeaderView else {
            return UICollectionReusableView()
        }
        
        if let image = UIImage(systemName: "pencil") {
            header.configure(image: image)
        }
        
        if let locality = placemark?.locality,
           let subLocality = placemark?.subLocality {
            header.configure(locality: locality, subLocality: subLocality)
        }
        
        if let temperatureMin = currentWeathermodel?.main?.tempMin,
           let temperatureMax = currentWeathermodel?.main?.tempMax,
           let temperatureCurrent = currentWeathermodel?.main?.temp {
            header.configure(temperatureMin: temperatureMin, temperatureMax: temperatureMax, temperatureCurrent: temperatureCurrent)
        }
        
        return header
    }
}
