import UIKit
import CoreLocation

final class WeatherForecastViewController: UIViewController {
    private let weatherForecastView = WeatherForecastView()
    
    private let locator = Locator()
    private let networker = Networker()
    
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
        //            requestData {
        //                group.leave()
        //            }
        requestData(coordinate: coordinate) {
            group.leave()
        }
        
        group.notify(queue: .global(qos: .userInteractive)) { [weak self] in
            guard let self = self else { return }
            guard let coordinate = coordinate else { return }
            
            group.enter()
            fetchCurrentWeatherData(coordinate: coordinate) {
                group.leave()
            }
            
            group.enter()
            fetchFiveDaysWeatherData(coordinate: coordinate) {
                group.leave()
            }
            
            group.wait()
            fetchUI()
        }
    }
    
    private func requestData(coordinate: CLLocationCoordinate2D?, completion: @escaping () -> Void) {
        locator.requestData(coordinate: coordinate) { [weak self] coordinate, placemark in
            self?.coordinate = coordinate
            self?.placemark = placemark
            completion()
        }
    }
    
    private func fetchCurrentWeatherData(coordinate: CLLocationCoordinate2D, completion: @escaping () -> Void) {
        networker.fetchWeatherData(request: WeatherAPI.current(coordinate)) { (result: Model.CurrentWeather) in
            self.currentWeathermodel = result
            completion()
        }
    }
    
    private func fetchFiveDaysWeatherData(coordinate: CLLocationCoordinate2D, completion: @escaping () -> Void) {
        networker.fetchWeatherData(request: WeatherAPI.fiveDays(coordinate)) { (result: Model.FiveDaysWeather) in
            self.fiveDaysWeatherModel = result
            completion()
        }
    }
    
    private func fetchUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            weatherForecastView.collectionView.reloadData()
            weatherForecastView.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    private func configureRefreshControl () {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            weatherForecastView.collectionView.refreshControl = UIRefreshControl()
            weatherForecastView.collectionView.refreshControl?.tintColor = .white
            weatherForecastView.collectionView.refreshControl?.addTarget(
                self,
                action: #selector(refreshWeatherData),
                for: .valueChanged
            )
        }
    }
    
    @objc
    func refreshWeatherData() {
        coordinate = nil
        configureWeatherData()
    }
    
    @objc
    func touchLocationConfigurationButton() {
        let alertController = UIAlertController(title: "위치 변경", message: "변경할 좌표를 선택해주세요", preferredStyle: .alert)
        
        let changeAction = UIAlertAction(title: "변경", style: .default) { [weak self] _ in
            
            guard let self = self,
                  let textFields = alertController.textFields,
                  let latitudeString = textFields[0].text,
                  let longitudeString = textFields[1].text,
                  let latitude = Double(latitudeString),
                  let longitude = Double(longitudeString) else {
                return
            }
            
            coordinate?.latitude = latitude
            coordinate?.longitude = longitude
            configureWeatherData()
        }
        
        let relocateCurrentAction = UIAlertAction(title: "현재 위치로 재설정", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            coordinate = nil
            configureWeatherData()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alertController.addTextField { textfield in
            textfield.placeholder = "위도"
            textfield.keyboardType = .decimalPad
        }
        
        alertController.addTextField { textfield in
            textfield.placeholder = "경도"
            textfield.keyboardType = .decimalPad
        }
        
        alertController.addAction(changeAction)
        alertController.addAction(relocateCurrentAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
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
