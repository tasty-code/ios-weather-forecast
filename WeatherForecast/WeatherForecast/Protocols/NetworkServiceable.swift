import Foundation

protocol NetworkServiceable {
    
    static func handlingDataResponse<T: Decodable>(data: Data?, response: URLResponse?, error: Error?, completionHandler: @escaping (Result<T, NetworkError>) -> Void)
}

extension NetworkServiceable {
    static func handlingDataResponse<T: Decodable>(data: Data?, response: URLResponse?, error: Error?, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        guard let data = data, error == nil else {
            return completionHandler(.failure(.invalidData))
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return completionHandler(.failure(.invalidResponse))
        }
        
        guard (200..<300) ~= httpResponse.statusCode else {
            print(httpResponse.statusCode)
            return completionHandler(.failure(.invalidResponse))
        }
        
        if let data = try? JSONDecoder().decode(T.self, from: data) {
            completionHandler(.success(data))
        } else {
            completionHandler(.failure(.decodingError))
        }
    }
}
