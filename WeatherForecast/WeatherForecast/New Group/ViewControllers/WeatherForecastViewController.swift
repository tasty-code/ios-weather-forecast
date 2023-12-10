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
        let cell: WeatherForecastCell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherForecastCell.identifier, for: indexPath) as! WeatherForecastCell
        
        // 아래 로직 view에서 처리.
        // MVC가 다소 어긋나기는 하지만 이정도 편의는 가져갈 수 있다.
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
        
        if let imageType = fiveDaysWeatherModel?.list?[indexPath.row].weather?[0].icon {
            //            networker?.fetchWeatherData { <#Decodable#> in
            //                <#code#>
            //            }
            //            cell.configure(image: image)
        }
        //        if let image = UIImage(systemName: "square.and.arrow.up") {
        //            cell.configure(image: image)
        //        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: WeatherForecastHeaderView.identifier, for: indexPath) as? WeatherForecastHeaderView else {
            return WeatherForecastHeaderView()
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
