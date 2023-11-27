import CoreLocation

typealias FetchLocationCompletion = (CLLocationCoordinate2D?, Error?) -> Void?

final class LocationManager: CLLocationManager {
    static let shared = LocationManager()
    
    private var fetchLocationCompletion: FetchLocationCompletion?
    private var coordinate: CLLocationCoordinate2D?
    
    override private init() {
        super.init()
        
        self.delegate = self
        self.distanceFilter = kCLDistanceFilterNone
        self.desiredAccuracy = kCLLocationAccuracyKilometer
        self.requestWhenInUseAuthorization()
        self.startUpdatingLocation()
    }
    
    
//    func fetchLocation(completion: @escaping FetchLocationCompletion) {
////        requestLocation()
//        startUpdatingLocation()
//        self.fetchLocationCompletion = completion
//    }
    func fetchLocation(completion: @escaping FetchLocationCompletion) {
           // Check if location is already available
           if let lastLocation = self.location {
               let coordinate = lastLocation.coordinate
               completion(coordinate, nil)
           } else {
               // If not available, start updating location and store the completion block
               startUpdatingLocation()
               self.fetchLocationCompletion = completion
           }
       }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let myCoordinate: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        print("LOCATION MANAGER")
        print(myCoordinate.latitude)
        print(myCoordinate.longitude)
        coordinate = myCoordinate
        self.fetchLocationCompletion?(coordinate, nil)
        self.fetchLocationCompletion = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to Fetch Location (\(error))")
        
        // 에러발생 시 저장된 값을 갖고 동작을 실행
        self.fetchLocationCompletion?(nil, error)
        // 위의 실행 후 클로저 초기화
        self.fetchLocationCompletion = nil
    }
    
    
    func getAddress() {
        guard let coordinate = location?.coordinate else {
            return
        }
            
//        let location = CLLocation(latitude: 37.533634, longitude: 126.963668)
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { [weak self] placemarks, _ in
            guard let placemarks = placemarks,
                  let address = placemarks.last
            else { return }
            DispatchQueue.main.async {
                print("\(address)")
            }
        }
    }
}

