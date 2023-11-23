protocol Networkable {
    func fetch(completion: @escaping (Result<Decodable, NetworkError>) -> Void)
}
