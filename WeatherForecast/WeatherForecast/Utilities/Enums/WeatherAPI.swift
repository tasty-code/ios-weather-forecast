import Foundation
import CoreLocation

enum WeatherAPI {
    case current
    case fiveDays
}

//extension WeatherAPI: Requestable, KeyAuthenticatable {
//    
//    var path: URL? {
//        let locationManager = LocationManager.shared
//        var location: CLLocationCoordinate2D?
//        var components = URLComponents(string: "https://api.openweathermap.org")
//
//        locationManager.fetchLocation { (myLocation, error) -> URL? in
//            location = myLocation
//            
//            guard let latitude = location?.latitude, let longitude = location?.longitude else {
//                return nil
//            }
//            
//            guard let APIKey = APIKey else {
//                return nil
//            }
//            
//            components?.queryItems = [
//                URLQueryItem(name: "lat", value: "\(latitude)"),
//                URLQueryItem(name: "lon", value: "\(longitude)"),
//                URLQueryItem(name: "appid", value: "\(APIKey)"),
//            ]
////            print(components?.url)
//
//            switch self {
//            case .current:
//                components?.path = "/data/2.5/weather"
//                return components?.url
//            case .fiveDays:
//                components?.path = "/data/2.5/forecast"
//                return components?.url
//            }
//        }
//    }
//}

extension WeatherAPI: Requestable, KeyAuthenticatable {

    func fetchPath(completion: @escaping (URL?) -> Void) {
        let locationManager = LocationManager.shared
        var location: CLLocationCoordinate2D?
        var components = URLComponents(string: "https://api.openweathermap.org")

        locationManager.fetchLocation { (myLocation, error) in
            location = myLocation

            guard let latitude = location?.latitude, let longitude = location?.longitude, let APIKey = APIKey else {
                completion(nil)
                return
            }

            components?.queryItems = [
                URLQueryItem(name: "lat", value: "\(latitude)"),
                URLQueryItem(name: "lon", value: "\(longitude)"),
                URLQueryItem(name: "appid", value: "\(APIKey)"),
            ]

            switch self {
            case .current:
                components?.path = "/data/2.5/weather"
                completion(components?.url)
            case .fiveDays:
                components?.path = "/data/2.5/forecast"
                completion(components?.url)
            }
        }
        locationManager.getAddress()
    }

    var path: URL? {
        var result: URL?
        fetchPath { url in
            result = url
        }

        print(result)
        return result
    }
}
