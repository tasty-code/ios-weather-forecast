protocol Networkable: AnyObject {
    func fetch<T: Decodable>(request: Requestable?, completion: @escaping (Result<T, NetworkError>) -> Void)
}
