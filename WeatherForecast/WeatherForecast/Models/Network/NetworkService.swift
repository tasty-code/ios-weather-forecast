import Foundation

class NetworkService {
    
    func getWeather<T: Decodable>(informationType: InformationType, latitude: Double, longitude: Double, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
         
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
                
                let weatherData = try? JSONDecoder().decode(T.self, from: data)

                if let weatherData = weatherData {
                    print(weatherData)
                    completionHandler(.success(weatherData))
                } else {
                    completionHandler(.failure(.decodingError))
                }
            }.resume()
        }
    
//    func getForecastWeather(completion: @escaping (Result<ForecastWeather, NetworkError>) -> Void) {
//        
//        guard let apiKey = apiKey else { return }
//        
//        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=37.6&lon=127&appid=\(apiKey)&lang=kr")
//          
//        guard let url = url else {
//                return completion(.failure(.invalidUrl))
//            }
//            
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                guard let data = data, error == nil else {
//                    return completion(.failure(.invalidData))
//                }
//                
//
//                let weatherResponse = try? JSONDecoder().decode(ForecastWeather.self, from: data)
//
//                if let weatherResponse = weatherResponse {
//                    print(weatherResponse)
//                    completion(.success(weatherResponse))
//                } else {
//                    completion(.failure(.decodingError))
//                }
//            }.resume()
//        }
}

