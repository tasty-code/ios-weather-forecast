import UIKit
import CoreLocation

final class WeatherForecastViewController: UIViewController {
    private let weatherForecastView = WeatherForecastView()
    
    private let locator = Locator()
    private var networker: Networker?
    
    private var currentWeathermodel: Model.CurrentWeather?
    private var fiveDaysWeatherModel: Model.FiveDaysWeather?
    private var coordinate: CLLocationCoordinate2D?
    private var placemark: CLPlacemark?
    
    override func loadView() {
        view = weatherForecastView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherForecastView.collectionView.delegate = self
        weatherForecastView.collectionView.dataSource = self
        
        configureWeatherData()
        configureRefreshControl()
    }
    
    @objc
    private func configureWeatherData() {
        let group = DispatchGroup()
        
        group.enter()
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.locator.requestData { coordinate, placemark in
                self?.coordinate = coordinate
                self?.placemark = placemark
                group.leave()
            }
        }
        
        group.notify(queue: .global(qos: .userInteractive)) {
            guard let coordinate = self.coordinate else {
                return
            }
            
            group.enter()
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                self?.networker = Networker(request: WeatherAPI.current(coordinate))
                self?.networker?.fetchWeatherData { (result: Model.CurrentWeather) in
                    self?.currentWeathermodel = result
                    group.leave()
                }
            }
            
            group.enter()
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                self?.networker = Networker(request: WeatherAPI.fiveDays(coordinate))
                self?.networker?.fetchWeatherData { (result: Model.FiveDaysWeather) in
                    self?.fiveDaysWeatherModel = result
                    group.leave()
                }
            }
            
            group.wait()
            
            DispatchQueue.main.async {
                self.weatherForecastView.collectionView.reloadData()
                self.weatherForecastView.collectionView.refreshControl?.endRefreshing()
            }
        }
    }
    
    private func configureRefreshControl () {
        DispatchQueue.main.async { [weak self] in
            self?.weatherForecastView.collectionView.refreshControl = UIRefreshControl()
            self?.weatherForecastView.collectionView.refreshControl?.tintColor = .white
            self?.weatherForecastView.collectionView.refreshControl?.addTarget(
                self,
                action: #selector(self?.configureWeatherData),
                for: .valueChanged
            )
        }
    }
}

extension WeatherForecastViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = fiveDaysWeatherModel?.list?.count else {
            return 20
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: WeatherForecastCell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherForecastCell.identifier, for: indexPath) as? WeatherForecastCell else {
            return WeatherForecastCell()
        }
        
        cell.configure(using: fiveDaysWeatherModel?.list?[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: WeatherForecastHeaderView.identifier, for: indexPath) as? WeatherForecastHeaderView else {
            return WeatherForecastHeaderView()
        }
        
        header.configure(placemark, using: currentWeathermodel)
      
        return header
    }
}

extension WeatherForecastViewController: UICollectionViewDelegate {
    
}
