import Foundation

final class NetworkService {

    private func createApiKey(name: String) -> String? {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: name) as? String
        return apiKey
    }
    
    private func createWeatherApiUrl(for informationType: InformationType,coordinate: Coordinate, apiKey: String) -> URL? {
        switch informationType{
        case .weather:
            return URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appid=\(apiKey)&lang=kr")
        case .forecast:
            return URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appid=\(apiKey)&lang=kr")
        }
    }
    
    func getWeatherData<T: Decodable>(keyName: String, informationType: InformationType,coordinate: Coordinate, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        
        let apiKey = createApiKey(name: keyName)
        guard let apiKey = apiKey else {
            return completionHandler(.failure(.invalidApikeyName))
        }
        
        let url = createWeatherApiUrl(for: informationType,coordinate: coordinate, apiKey: apiKey)
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
