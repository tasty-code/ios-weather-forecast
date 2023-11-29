import CoreLocation

protocol UILocationDelegate: AnyObject {
    func updateUI(coordinate: CLLocationCoordinate2D?)
    func updatePlacemark(placemark: CLPlacemark)
}
