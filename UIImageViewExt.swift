
import UIKit

extension UIImageView {
    func tintImageColor(color: UIColor) {
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        tintColor = color
    }
}
