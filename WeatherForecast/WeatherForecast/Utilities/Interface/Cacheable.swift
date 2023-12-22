import UIKit

protocol Cacheable {
    func loadImage(with imageID: String) -> UIImage?
    func store(with imageID: String, image: UIImage)
}
