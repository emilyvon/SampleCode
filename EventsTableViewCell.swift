
import UIKit
import ParseUI

class EventsTableViewCell: PFTableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var eventImageView: PFImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    private func resetContent() {
        eventImageView.image = UIImage(named: "placeholder_danceaus")
        nameLabel.text = String()
        dateLabel.text = String()
        dateLabel.isHidden = false
    }
    
    func configCell(object: PFObject?) {
        resetContent()
        
        if let obj = object as? OrganiserEvent {
            configCell(organiserEvent: obj)
        } else if let obj = object as? Organiser {
            configCell(organiser: obj)
        } else {
            print("this object is neither OrganiserEvent or Organiser")
        }
    }
    
    private func configCell(organiserEvent: OrganiserEvent) {
        nameLabel.text = organiserEvent.name
        dateLabel.text = organiserEvent.runsFrom?.toLocalDateStringWithShortYear()
        eventImageView.file = getOrganiserImageFile(with: organiserEvent)
        eventImageView.loadInBackground()
    }
    
    private func configCell(organiser: Organiser) {
        nameLabel.text = organiser.name
        dateLabel.isHidden = true // Organiser doesn't have a date field and we are reusing the same UI, so we just simply hide it
        eventImageView.file = organiser.photo
        eventImageView.loadInBackground()
    }
    
    private func getOrganiserImageFile(with event: OrganiserEvent) -> PFFile? {
        if let organiser = SessionManager.shared.getOrganiser(withEvent: event) {
            return organiser.photo
        }
        return nil
    }
}
