import Foundation

protocol APIRequestable {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var parameters: [String: String]? { get }

    func makeURL() -> URL?
}
    
extension APIRequestable {
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
}
