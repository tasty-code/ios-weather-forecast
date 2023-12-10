import CoreLocation

struct Locator {
    private let locationManager = LocationManager()
    
    func requestData(completion: @escaping (CLLocationCoordinate2D, CLPlacemark) -> Void) {

        locationManager.request { result in
            switch result {
            case .success((let coordinate, let placemark)):
                completion(coordinate, placemark)
            case .failure(let error):
                print(error)
            }
        }
    }
}
