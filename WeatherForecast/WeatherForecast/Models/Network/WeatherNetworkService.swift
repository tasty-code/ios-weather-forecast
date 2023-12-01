import Foundation

final class WeatherNetworkService: NetworkServiceable {
    
    static func getWeatherData<T: Decodable>(weatherType: WeatherType, coordinate: Coordinate, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        let weatherURL = WeatherURLConfigration(coordinate: coordinate, weatherType: weatherType.rawValue)
        
        guard let _ = weatherURL.apiKey else {
            return completionHandler(.failure(.invalidAPIKEYName))
        }
        
        guard let url = weatherURL.makeURL() else {
            return completionHandler(.failure(.invalidUrl))
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            handlingDataResponse(data: data, response: response, error: error, completionHandler: completionHandler)
        }.resume()
    }
}
