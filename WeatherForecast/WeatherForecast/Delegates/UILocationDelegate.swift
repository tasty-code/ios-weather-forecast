import CoreLocation

protocol UILocationDelegate: AnyObject {
    func update(coordinate: CLLocationCoordinate2D?)
    func update(placemark: CLPlacemark)
}
