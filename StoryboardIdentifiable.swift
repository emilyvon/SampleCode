
import UIKit

protocol StoryboardIdentifiable {
    static var storyboardId: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardId: String {
        return String(describing: self)
    }
    
    static var instanceInMain: UIViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: storyboardId)
    }
}

extension UIViewController: StoryboardIdentifiable {}
