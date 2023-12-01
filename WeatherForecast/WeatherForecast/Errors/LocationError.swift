enum LocationError: Error {
    case failedFetchLocationError
    case noLocationError
    case noPlacemarkError
    case noLocationAuthorizationError
    case unknownLocationAuthorizationError
}
