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
    
    private func configureWeatherData() {
        let group = DispatchGroup()
        
        group.enter()
        DispatchQueue.global(qos: .userInteractive).async {
            self.locator.requestData { coordinate, placemark in
                self.coordinate = coordinate
                self.placemark = placemark
                group.leave()
            }
        }
        group.notify(queue: .global(qos: .userInteractive)) {
            guard let coordinate = self.coordinate else {
                return
            }
            
            group.enter()
            DispatchQueue.global(qos: .userInteractive).async {
                self.networker = Networker(request: WeatherAPI.current(coordinate))
                self.networker?.fetchWeatherData { (result: Model.CurrentWeather) in
                    self.currentWeathermodel = result
                    group.leave()
                }
            }
            
            group.enter()
            DispatchQueue.global(qos: .userInteractive).async {
                self.networker = Networker(request: WeatherAPI.fiveDays(coordinate))
                self.networker?.fetchWeatherData { (result: Model.FiveDaysWeather) in
                    self.fiveDaysWeatherModel = result
                    group.leave()
                }
            }
            
            group.wait()
            
            DispatchQueue.main.async {
                self.weatherForecastView.collectionView.reloadData()
            }
        }
    }
    
    private func configureRefreshControl () {
        weatherForecastView.collectionView.refreshControl = UIRefreshControl()
        weatherForecastView.collectionView.refreshControl?.addTarget(
            self,
            action: #selector(handleRefreshControl),
            for: .valueChanged
        )
    }
    
    @objc
    private func handleRefreshControl() {
        configureWeatherData()
        
        DispatchQueue.main.async {
            self.weatherForecastView.collectionView.refreshControl?.endRefreshing()
        }
    }
}

extension WeatherForecastViewController: UICollectionViewDelegate {
    
}

extension WeatherForecastViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = fiveDaysWeatherModel?.list?.count else {
            return .zero
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: WeatherForecastCell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherForecastCell.identifier, for: indexPath) as? WeatherForecastCell else {
            return WeatherForecastCell()
        }
        
        do {
            try cell.startConfigure(using: fiveDaysWeatherModel?.list?[indexPath.row])
        } catch {
            print(error)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: WeatherForecastHeaderView.identifier, for: indexPath) as? WeatherForecastHeaderView else {
            return WeatherForecastHeaderView()
        }
        
        do {
            try header.startConfigure(placemark, using: currentWeathermodel)
        } catch {
            print(error)
        }
        
        return header
    }
}
