
import UIKit

protocol CellIdentifiable {
    static var cellIdentifier: String { get }
}

// MARK: - UITableViewCell
extension CellIdentifiable where Self: UITableViewCell {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}
extension UITableViewCell: CellIdentifiable {}


// MARK: - UICollectionViewCell
extension CellIdentifiable where Self: UICollectionViewCell {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}
extension UICollectionViewCell: CellIdentifiable {}
