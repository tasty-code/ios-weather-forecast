import Foundation

final class NetworkService {
    
    
    
    func getWeatherData<T: Decodable>(informationType: InformationType, latitude: Double, longitude: Double, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
        
        guard let apiKey = apiKey else { return }
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/\(informationType)?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&lang=kr")
        
        guard let url = url else {
            return completionHandler(.failure(.invalidUrl))
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return completionHandler(.failure(.invalidData))
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

