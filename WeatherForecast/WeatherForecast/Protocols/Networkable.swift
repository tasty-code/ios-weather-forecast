protocol Networkable: AnyObject {
    func fetch<T: Decodable>(completion: @escaping (Result<T, NetworkError>) -> Void)
}
