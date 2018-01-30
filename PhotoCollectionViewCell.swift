
import UIKit
import ParseUI

class PhotoCollectionViewCell: PFCollectionViewCell {

    @IBOutlet weak var photoImageView: PFImageView!
    
    func configCell(file: PFFile?) {
        photoImageView.image = UIImage(named: "placeholderRectangle") // Default image
        photoImageView.file = file
        photoImageView.loadInBackground()
    }

}
