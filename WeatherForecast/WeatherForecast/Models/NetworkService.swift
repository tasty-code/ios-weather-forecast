import Foundation

enum NetworkError: Error {
    case badUrl
    case noData
    case decodingError
}


class NetworkService {

    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
    
    func getNowWeather(completion: @escaping (Result<CurrentWeather, NetworkError>) -> Void) {
        
        guard let apiKey = apiKey else { return }
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=37.6&lon=127&appid=\(apiKey)&lang=kr")
          
        guard let url = url else {
                return completion(.failure(.badUrl))
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    return completion(.failure(.noData))
                }
                

                let weatherResponse = try? JSONDecoder().decode(CurrentWeather.self, from: data)


                if let weatherResponse = weatherResponse {
                    print(weatherResponse)
                    completion(.success(weatherResponse))
                } else {
                    completion(.failure(.decodingError))
                    print(" tq")
                }
            }.resume()
        }
    
    func getForecastWeather(completion: @escaping (Result<ForecastWeather, NetworkError>) -> Void) {
        
        guard let apiKey = apiKey else { return }
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=37.6&lon=127&appid=\(apiKey)&lang=kr")
          
        guard let url = url else {
                return completion(.failure(.badUrl))
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    return completion(.failure(.noData))
                }
                

                let weatherResponse = try? JSONDecoder().decode(ForecastWeather.self, from: data)

                if let weatherResponse = weatherResponse {
                    print(weatherResponse)
                    completion(.success(weatherResponse))
                } else {
                    completion(.failure(.decodingError))
                    print(" tq")
                }
            }.resume()
        }
}
