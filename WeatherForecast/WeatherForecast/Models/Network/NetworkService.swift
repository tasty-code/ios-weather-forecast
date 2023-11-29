import Foundation

final class NetworkService {
    
    static func getWeatherData<T: Decodable>(weatherType: WeatherType, coordinate: Coordinate, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        
        let url = WeatherURLConfigration(coordinate: coordinate, weatherType: weatherType)?.makeURL()
        guard let url = url else {
            return completionHandler(.failure(.invalidUrl))
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return completionHandler(
                    .failure(.invalidData))
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            guard (200..<300) ~= response.statusCode else {
                return completionHandler(.failure(.invalidResponse))
            }
            
            let weatherData = try? JSONDecoder().decode(T.self, from: data)
            
            if let weatherData = weatherData {
                completionHandler(.success(weatherData))
            } else {
                completionHandler(.failure(.decodingError))
            }
        }.resume()
    }
}
