import Foundation

protocol APIRequestable {
    
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var parameters: [String: String]? { get }
    var apiKey: String? { get }
    
    func createApiKey(name: String) -> String?
    func makeURL() -> URL?
}

extension APIRequestable {
    
    func createApiKey(name: String) -> String? {
        let apiKey = Bundle.main.object(forInfoDictionaryKey: name) as? String
        return apiKey
    }
    
    func makeURL() -> URL? {
        var components = URLComponents()
        
        components.scheme = self.scheme
        components.host = self.host
        components.path = self.path
        components.queryItems = self.parameters?.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        return components.url
    }
    
    func checkError(completionHandler: @escaping (Result<URL, NetworkError>) -> Void) {
        
        guard let _ = apiKey else {
            return completionHandler(.failure(.invalidAPIKEYName))
        }
        
        guard let url = makeURL() else {
            return completionHandler(.failure(.invalidUrl))
        }
        completionHandler(.success(url))
    }

}
